var container, stats;
var camera, scene, renderer;

var raycaster;
var mouse;

var config =
  { n: 8,
    box_size: 30,
    nice_shading: false
  };

init(config);
animate();

function init(config) {
    var clear_color = "white";

    // META
    container = document.createElement( 'div' );
    document.body.appendChild( container );

    var info = document.createElement( 'div' );
    info.style.position = 'absolute';
    info.style.top = '10px';
    info.style.width = '100%';
    info.style.textAlign = 'center';
    info.innerHTML = '<a href="http://threejs.org" target="_blank">three.js</a> - patchwork prototype';
    container.appendChild( info );

    renderer = new THREE.WebGLRenderer( {antialias: true } );
//    renderer = new THREE.CanvasRenderer();
    renderer.setClearColor( clear_color );
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize( window.innerWidth, window.innerHeight );
    container.appendChild(renderer.domElement);

    // CAMERA
    camera = new THREE.PerspectiveCamera( 70, window.innerWidth / window.innerHeight, 1, 3000 );
    camera.position.y = 300;
    camera.position.z = 500;

    scene = new THREE.Scene();
    scene.fog = new THREE.Fog( clear_color, 1000, 3000 );

    var lights = [];
    if (config.nice_shading) {
        var hemi = new THREE.HemisphereLight(
            0xffffff, 0xffffff, 1.2
        );
        hemi.color.setHSL( 0.6, 1, 0.75 );
        hemi.groundColor.setHSL( 0.1, 0.8, 0.7 );
        hemi.position.y = 2000;

        lights.push( hemi );
    }
    lights.forEach(function(l) { scene.add(l); });

    var geometry = new THREE.BoxGeometry(
            0.9 * config.box_size, 0.9 * config.box_size, 0.9 * config.box_size );
    var texture = THREE.ImageUtils.loadTexture( 'textures/crate.gif' );
    texture.anisotropy = renderer.getMaxAnisotropy();

    for ( var x = 0; x < config.n; x ++ ) {
    for ( var y = 0; y < config.n; y ++ ) {
    for ( var z = 0; z < config.n; z ++ ) {
        var material;
        var col = new THREE.Color( x/config.n, y/config.n, z/config.n );

        if (config.nice_shading) {
            material = new THREE.MeshPhongMaterial(
                    { //map: texture,
                      shininess: 1, color: col });
        } else {
            material = new THREE.MeshBasicMaterial(
                    { //map: texture,
                      color: col });
        }

        var object = new THREE.Mesh( geometry, material );
        var cs = from_grid( {x: x, y: y, z: z} );
        object.position.x = cs.x;
        object.position.y = cs.y;
        object.position.z = cs.z;

        if (x === 0) {
            object.solid = true;
            object.laser = Math.floor(Math.random() * 6);
        } else {
            object.solid = false;
        }

        scene.add( object );
    }
    }
    }

    //

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

    //

    window.addEventListener( 'resize', onWindowResize, false );

}

function onWindowResize() {

    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );

}

function onDocumentTouchEnd( event ) {

    event.preventDefault();

    event.clientX = event.touches[0].clientX;
    event.clientY = event.touches[0].clientY;
    onDocumentMouseDown( event );

}

function onDocumentMouseUp( event ) {

    event.preventDefault();

    mouse.x = ( event.clientX / renderer.domElement.width ) * 2 - 1;
    mouse.y = - ( event.clientY / renderer.domElement.height ) * 2 + 1;

    raycaster.setFromCamera( mouse, camera );

    var intersects = raycaster.intersectObjects( scene.children );

    if ( intersects.length > 0 ) {

        var obj = intersects[ 0 ].object;
        obj.material.color = new THREE.Color("red");

        if (!obj.solid) {
            new TWEEN.Tween( obj.position ).to( {
                x: 3100 * Math.sign(obj.position.x),
                y: 3100 * Math.sign(obj.position.y),
                z: 3100 * Math.sign(obj.position.z)}
                , 20000 )
            .easing( TWEEN.Easing.Elastic.Out).start();
        } else {
            var coords = to_grid(obj.position);
            if (coords.y == 0 && coords.z == 0) {
                new TWEEN.Tween( obj.scale ).to( {
                    x: config.n * 2 + 1,
                    y: config.n * 2 + 1,
                    z: config.n * 2 + 1
                    } , 1000 )
                .easing( TWEEN.Easing.Elastic.Out).start();
                obj.material.color = new THREE.Color("gold");
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

function to_grid(position) {
    var box_size = config.box_size;
    var n = config.n;

    return {
        x: (position.x + n * box_size / 2) / box_size,
        y: (position.y + n * box_size / 2) / box_size,
        z: (position.z + n * box_size / 2) / box_size
    }
}

function from_grid(position) {
        var box_size = config.box_size;
        var n = config.n;
        return {
            x: position.x * box_size - n * box_size / 2,
            y: position.y * box_size - n * box_size / 2,
            z: position.z * box_size - n * box_size / 2
        };
}
