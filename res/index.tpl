<!DOCTYPE html>
<html lang="en-GB">
<head>
	<title>Offline</title>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<meta name="theme-color" content="#ff0000"/>
	<link rel="manifest" href="manifest.webmanifest"/>

	<style>
		html, body{
			width: 100%;
			height: 100%;
			margin: 0;
			padding: 0;
		}
		canvas{
			max-width: 100%;
			max-height: 100%;
			margin: auto;
			display: block;
		}
	</style>
</head>
<body lang="en-US">
	<canvas width="2160" height="3840"></canvas>
	<script>
		if ('serviceWorker' in navigator) {
			navigator.serviceWorker.register('./worker.js');
		}
	</script>
	<script>::src::</script>
	<noscript>Javascript must be enebled to run this game</noscript>
</body>
</html>