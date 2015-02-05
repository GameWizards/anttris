var container, stats;
var camera, scene, renderer;

var raycaster;
var mouse;

var n = 5;
var box_size = 100;

init(n, box_size);
animate();


function init(n, box_size) {
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

    renderer = new THREE.WebGLRenderer( {antialias: true } ); // THREE.CanvasRenderer();
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

    var geometry = new THREE.BoxGeometry( box_size, box_size, box_size );
    var texture = THREE.ImageUtils.loadTexture( 'textures/crate.gif' );
    texture.anisotropy = renderer.getMaxAnisotropy();

    for ( var x = 0; x < n; x ++ ) {
    for ( var y = 0; y < n; y ++ ) {
    for ( var z = 0; z < n; z ++ ) {
        var material = new THREE.MeshBasicMaterial(
                { map: texture
                 ,color: new THREE.Color(0.1 + x/n, 0.1 + y/n, 0.1 + z/n)} );

        var object = new THREE.Mesh( geometry, material );
        var cs = grid_coords(x, y, z);
        object.position.x = cs.x;
        object.position.y = cs.y;
        object.position.z = cs.z;

        if (x === 0) {
            object.solid = true;
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

    document.addEventListener( 'mousedown', onDocumentMouseDown, false );
    document.addEventListener( 'touchstart', onDocumentTouchStart, false );

    //

    window.addEventListener( 'resize', onWindowResize, false );

}

function onWindowResize() {

    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );

}

function onDocumentTouchStart( event ) {

    event.preventDefault();

    event.clientX = event.touches[0].clientX;
    event.clientY = event.touches[0].clientY;
    onDocumentMouseDown( event );

}

function onDocumentMouseDown( event ) {

    event.preventDefault();

    mouse.x = ( event.clientX / renderer.domElement.width ) * 2 - 1;
    mouse.y = - ( event.clientY / renderer.domElement.height ) * 2 + 1;

    raycaster.setFromCamera( mouse, camera );

    var intersects = raycaster.intersectObjects( scene.children );

    if ( intersects.length > 0 ) {

        var obj = intersects[ 0 ].object;
        if (!obj.solid) {
            new TWEEN.Tween( obj.position ).to( {
                x: 3100,
                y: 3100,
                z: 3100}
                , 20000 )
            .easing( TWEEN.Easing.Elastic.Out).start();
        }
        obj.material.color = 0xffffff;
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

function grid_coords(x, y, z) {
        return {
        x: x * box_size - n * box_size / 2,
        y: y * box_size - n * box_size / 2,
        z: z * box_size - n * box_size / 2 };
}


