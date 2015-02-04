var container, stats;
var camera, scene, renderer;

var raycaster;
var mouse;

init();
animate();

function init() {

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

    // CAMERA
    camera = new THREE.PerspectiveCamera( 70, window.innerWidth / window.innerHeight, 1, 10000 );
    camera.position.y = 300;
    camera.position.z = 500;

    scene = new THREE.Scene();
    scene.fog = new THREE.Fog( 0xffffff, 3000, 10000 );

    // LIGHTS
    //var directionalLight = new THREE.DirectionalLight( 0xffffff, 0.475 );
    //directionalLight.position.set( 2600, 2600, -2600 );
    //scene.add( directionalLight );

    //var hemiLight = new THREE.HemisphereLight( 0xffffff, 0xffffff, 1.25 );
    //hemiLight.color.setHSL( 0.6, 1, 0.75 );
    //hemiLight.groundColor.setHSL( 0.1, 0.8, 0.7 );
    //hemiLight.position.y = 2800;
    //scene.add( hemiLight );

    // SKYBOX
    // /webgl_materials_lightmap.html

    //var vertexShader = document.getElementById( 'vertexShader' ).textContent;
    //var fragmentShader = document.getElementById( 'fragmentShader' ).textContent;

    //var vertexShader = document.getElementById( 'vertexShader' ).textContent;
    //var fragmentShader = document.getElementById( 'fragmentShader' ).textContent;
    //var uniforms = {
    //    topColor:   { type: "c", value: new THREE.Color( 0x0077ff ) },
    //    bottomColor:{ type: "c", value: new THREE.Color( 0xffffff ) },
    //    offset:     { type: "f", value: 400 },
    //    exponent:   { type: "f", value: 0.6 }
    //}
    //uniforms.topColor.value.copy( hemiLight.color );

    //scene.fog.color.copy( uniforms.bottomColor.value );

    //var skyGeo = new THREE.SphereGeometry( 4000, 32, 15 );
    //var skyMat = new THREE.ShaderMaterial( {
    //	uniforms: uniforms,
    //	vertexShader: vertexShader,
    //	fragmentShader: fragmentShader,
    //	side: THREE.BackSide
    //} );

    //var sky = new THREE.Mesh( skyGeo, skyMat );
    //scene.add( sky );


    // cube of cubes
    //

    var box_size = 100;
    var geometry = new THREE.BoxGeometry( box_size, box_size, box_size );
    var n = 5;
    for ( var x = 0; x < n; x ++ ) {
    for ( var y = 0; y < n; y ++ ) {
    for ( var z = 0; z < n; z ++ ) {

        var object = new THREE.Mesh( geometry, new THREE.MeshBasicMaterial(
                    { color: 0xffbb00 + 0xff * (Math.sin(x) + 20 * Math.cos(Math.cos(y)) + 20 * Math.cos(Math.sin(z)))
                    } ) );
        object.position.x = x * box_size - n * box_size / 2;
        object.position.y = y * box_size - n * box_size / 2;
        object.position.z = z * box_size - n * box_size / 2;
        scene.add( object );

    }
    }
    }

    //

    raycaster = new THREE.Raycaster();
    mouse = new THREE.Vector2();

    renderer = new THREE.WebGLRenderer( {antialias: true } ); // THREE.CanvasRenderer();
    renderer.setClearColor( 0xf0f0f0 );
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize( window.innerWidth, window.innerHeight );
    container.appendChild(renderer.domElement);

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
        new TWEEN.Tween( obj.position ).to( {
            //x: Math.random() * 800 - 400,
            //y: Math.random() * 800 - 400,
            //z: Math.random() * 800 - 400 }
            x: obj.position.x * 3,
            y: obj.position.y * 3,
            z: obj.position.z * 3}
            , 2000 )
        .easing( TWEEN.Easing.Elastic.Out).start();

        //new TWEEN.Tween( intersects[ 0 ].object.rotation ).to( {
        //    x: Math.random() * 2 * Math.PI,
        //    y: Math.random() * 2 * Math.PI,
        //    z: Math.random() * 2 * Math.PI }, 2000 )
        //.easing( TWEEN.Easing.Elastic.Out).start();

    }

    /*
    // Parse all the faces
    for ( var i in intersects ) {

        intersects[ i ].face.material[ 0 ].color.setHex( Math.random() * 0xffffff | 0x80000000 );

    }
    */
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

    theta += 0.1;

    //camera.position.x = radius * Math.sin( THREE.Math.degToRad( theta ) );
    //camera.position.y = radius * Math.sin( THREE.Math.degToRad( theta ) );
    //camera.position.z = radius * Math.cos( THREE.Math.degToRad( theta ) );
    //camera.lookAt( scene.position );

    controls.update();

    renderer.render( scene, camera );

}
