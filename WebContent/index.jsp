<html>
   <head>
      <title>File Uploading Form</title>
      <link href='https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB' crossorigin='anonymous'>
   </head>
   
   <body class="container">
   

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
      <div class="container">
        <a class="navbar-brand" href="#">PBO 6</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
      </div>
    </nav>

    <!-- Page Content -->
    <div class="container">
      <div class="row">
        <div class="col-lg-12 text-center" style="margin-top: 100px">
        	<h2>APLIKASI PENDETEKSIAN BENDA PADA GAMBAR<br/>MENGGUNAKAN AWS REKOGNITION</h2>
        	<div class="row">
        		<div class="col-md-4">
        		</div>
        		<div class="col-md-4">
			      <form action="pages/upload.jsp" method = "post"
			         enctype = "multipart/form-data" style="margin-top: 50px;">
					  <div class="form-group">
					    <label for="email"><h3>Pilih Gambar</h3></label>
					    <input type = "file" class="form-control" name = "file" size = "50" accept=".jpg" />
					  </div>
			         <input type = "submit" value = "Upload File" class="btn btn-primary"/>
				  </form>
        		</div>
        		<div class="col-md-4">
        		</div>
        	</div>
        </div>
      </div>
      	<div class="row" style="margin-top: 30px;">
      		<div class="col-md-4">
      		</div>
      		<div class="col-md-4" style="text-align: center;">
      			<h3>Dibuat oleh:</h3>
      			<p style='margin:0px;'>0617124001 - Asep Maulana Ismail</p>
      			<p style='margin:0px;'>0617124007 - Annas S</p>
      		</div>
      		<div class="col-md-4">
      		</div>
      	</div>
    </div>
   </body>
   
</html>