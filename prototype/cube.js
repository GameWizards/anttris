
var camera, scene, renderer;
var mesh;

init();
animate();

function init() {

	renderer = new THREE.WebGLRenderer();
	renderer.setPixelRatio( window.devicePixelRatio );
	renderer.setSize( window.innerWidth, window.innerHeight );
	document.body.appendChild( renderer.domElement );

	camera = new THREE.PerspectiveCamera( 70, window.innerWidth / 1000 );
	camera.position.z = 400;

	scene = new THREE.Scene();

	var geometry = new THREE.BoxGeometry( 200, 200, 200 );

	var texture = THREE.ImageUtils.loadTexture( 'textures/crate.gif' );
	texture.anisotropy = renderer.getMaxAnisotropy();

	var material = new THREE.MeshBasicMaterial( { map: texture } );

	mesh = new THREE.Mesh( geometry, material );
	scene.add( mesh );

	window.addEventListener( 'resize', onWindowResize, false );

}

function onWindowResize() {

	camera.aspect = window.innerWidth / window.innerHeight;
	camera.updateProjectionMatrix();

	renderer.setSize( window.innerWidth, window.innerHeight );

}

function animate() {

	requestAnimationFrame( animate );

	mesh.rotation.x += 0.005;
	mesh.rotation.y += 0.01;

	renderer.render( scene, camera );

}
