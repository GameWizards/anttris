var container, stats, controls;
var camera, scene, renderer;

var raycaster;
var mouse;

var info;

var grid_objects = [];

var config =
  { n: 8,
    box_size: 30,
    quit: false,
    clear_color: "white",
    nice_shading: false
  };

init();
init_level(config);
animate();

function init() {
    container = document.createElement( 'div' );
    document.body.appendChild( container );

    info = document.createElement( 'div' );
    info.style.position = 'absolute';
    info.style.top = '10px';
    info.style.width = '100%';
    info.style.textAlign = 'center';
    info.innerHTML = '<a href="http://threejs.org" target="_blank">three.js</a> - patchwork prototype';
    container.appendChild( info );

    renderer = new THREE.WebGLRenderer( {antialias: true } );
    renderer.setClearColor( config.clear_color );
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize( window.innerWidth, window.innerHeight );
    container.appendChild(renderer.domElement);

    // CAMERA
    camera = new THREE.PerspectiveCamera( 70, window.innerWidth / window.innerHeight, 1, 3000 );
    camera.position.y = 300;
    camera.position.z = 500;

    raycaster = new THREE.Raycaster();
    mouse = new THREE.Vector2();

    controls = new THREE.OrbitControls( camera, renderer.domElement );
    controls.target.set( 0, 0, 0 );

    stats = new Stats();
    stats.domElement.style.position = 'absolute';
    stats.domElement.style.top = '0px';
    container.appendChild( stats.domElement );

    document.addEventListener( 'mouseup', onDocumentMouseUp, false );
    document.addEventListener( 'touchend', onDocumentTouchEnd, false );
    document.addEventListener( 'touchstart', onDocumentTouchStart, false );

    window.addEventListener( 'resize', onWindowResize, false );


}

function init_level(config) {
    config.quit = false;
    grid_objects = [];

    scene = new THREE.Scene();
    scene.fog = new THREE.Fog( config.clear_color, 1000, 3000 );

    if (config.nice_shading) {
        var hemi = new THREE.HemisphereLight(
            0xffffff, 0xffffff, 1.2
        );
        hemi.color.setHSL( 0.6, 1, 0.75 );
        hemi.groundColor.setHSL( 0.1, 0.8, 0.7 );
        hemi.position.y = 2000;

        scene.add( hemi );
    }

    var c = 0.95;
    var geometry = new THREE.BoxGeometry(
            c * config.box_size, c * config.box_size, c * config.box_size );

    var texture = THREE.ImageUtils.loadTexture( 'textures/crate.gif' );
    texture.anisotropy = renderer.getMaxAnisotropy();

    for ( var x = 0; x < config.n; x ++ ) {
    for ( var y = 0; y < config.n; y ++ ) {
    for ( var z = 0; z < config.n; z ++ ) {
        var material;
        var col = new THREE.Color( x/config.n, y/config.n, z/config.n );

        if (config.nice_shading) {
            material = new THREE.MeshPhongMaterial(
                    { map: texture,
                      shininess: 1, color: col });
        } else {
            material = new THREE.MeshBasicMaterial(
                    { map: texture,
                      color: col });
        }

        var object = new THREE.Mesh( geometry, material );

        place_object(object, x, y, z);

        if (x === 0) {

            // explode
            object.hp = 3;
            object.onclick = [block_action("boom")];
            object.winner = false;

        } else {

            object.hp = 1;
            object.solid = false;
            if (Math.random() > 0.5) {

                // pick a random action
                object.onclick = [block_action()];

            } else {

                // be a normal block
                object.onclick = [fly_away]

            }
        }

        scene.add( object );
    }
    }
    }

    retrieve_object({x:0, y:0, z:0}).winner = true;
    retrieve_object({x:0, y:0, z:0}).onclick = [win];
}

function onWindowResize() {

    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );

}

function onDocumentTouchStart( e ) {
    onDocumentTouchEnd( e );
}

function onDocumentTouchEnd( event ) {

    event.preventDefault();

    event.clientX = event.touches[0].clientX;
    event.clientY = event.touches[0].clientY;
    onDocumentMouseDown( event );

}

function onDocumentMouseUp( event ) {

    if (config.quit) { return; }

    event.preventDefault();

    mouse.x = ( event.clientX / renderer.domElement.width ) * 2 - 1;
    mouse.y = - ( event.clientY / renderer.domElement.height ) * 2 + 1;

    raycaster.setFromCamera( mouse, camera );

    var intersects = raycaster.intersectObjects( scene.children );

    if ( intersects.length > 0 ) {

        var obj = intersects[ 0 ].object;

        // invert color
        obj.material.color.multiplyScalar(-1);
        obj.material.color.addScalar(1);

        var coords = to_grid(obj.position);

        if (obj.winner) {
            win(obj);
        } else {

            // run each action if HP < 1
            obj.hp -= 1;
            if (obj.hp === 0) {
                obj.onclick.forEach(function (f) { f(obj); });
            }
        }

    }
}

//

function animate() {

    requestAnimationFrame( animate );

    render();
    stats.update();

}

var radius = 600;
var theta = 0;

function render() {

    TWEEN.update();

    controls.update();

    renderer.render( scene, camera );

}

// returns grid points of a "real-world" object
function to_grid(position) {
    var box_size = config.box_size;
    var n = config.n;

    return {
        x: (position.x + n * box_size / 2) / box_size,
        y: (position.y + n * box_size / 2) / box_size,
        z: (position.z + n * box_size / 2) / box_size
    }
}

// converts real coordinates into a gridded system
function from_grid(position) {
        var box_size = config.box_size;
        var n = config.n;

        return {
            x: position.x * box_size - n * box_size / 2,
            y: position.y * box_size - n * box_size / 2,
            z: position.z * box_size - n * box_size / 2
        };
}

function place_object(object, x, y, z) {

        var cs = from_grid({ x: x, y: y, z: z });

        object.position.x = cs.x;
        object.position.y = cs.y;
        object.position.z = cs.z;

        grid_objects[x + config.n * y + config.n * config.n * z] = object;

}

// p = position
function retrieve_object(p) {
    return grid_objects
        [p.x + config.n * p.y + config.n * config.n * p.z];
}

function fly_away(obj) {
    new TWEEN.Tween( obj.position ).to( {
        x: 3100 * Math.sign(obj.position.x),
        y: 3100 * Math.sign(obj.position.y),
        z: 3100 * Math.sign(obj.position.z)}
        , 20000 )
    .easing( TWEEN.Easing.Elastic.Out).start();
}

function scale_to(obj, scale) {
    new TWEEN.Tween( obj.scale ).to( {
        x: scale,
        y: scale,
        z: scale
        } , 1000 )
    .easing( TWEEN.Easing.Elastic.Out).start();
}

function win(obj) {
    scale_to(obj, config.n * 2);

    obj.material.color = new THREE.Color("gold");

    info.innerHTML =
        "YOU WIN! <a href=\"javascript:window.location.reload(false);\">PLAY AGAIN?</a>";

    // zoom out
    new TWEEN.Tween( camera.position ).to( {
        x: camera.position.x * 3,
        y: camera.position.y * 3,
        z: camera.position.z * 3}
        , 300 )
    .easing( TWEEN.Easing.Elastic.Out).start();

    config.quit = true;
}

function boom(obj) {
    var cs = to_grid(obj.position);

    // clear out a 3x3 cube
    for (var xoff = -1; xoff <= 1; xoff++ ) {
    for (var yoff = -1; yoff <= 1; yoff++ ) {
    for (var zoff = -1; zoff <= 1; zoff++ ) {

        neighbor = retrieve_object({ x: cs.x + xoff, y: cs.y + yoff, z: cs.z + zoff });

        if (neighbor !== undefined) {
            if (neighbor.winner === false) {
                fly_away(neighbor);
            }
        }
    }
    }
    }
    fly_away(obj);
}

function block_action() {
    // each of these takes a THREE.js mesh object as the first argument
    var actions = { boom: boom, shrink: function(b) { scale_to(b, 0.1); }
    };

    if (arguments.length === 1) {

        return actions[arguments[0]];

    } else {

        // http://stackoverflow.com/questions/2532218/pick-random-property-from-a-javascript-object

        var keys = Object.keys(actions);

        return actions[keys[ keys.length * Math.random() << 0]];
    }
}
