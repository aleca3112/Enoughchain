<!-- Sign In Start -->
<div class="container-fluid">
	<div class="row h-100 align-items-center justify-content-center" style="min-height: 100vh;">
		<div class="col-12 col-sm-8 col-md-6">
			<div class="bg-light rounded p-4 p-sm-5 my-4 mx-3">
				<div class="d-flex align-items-center justify-content-between mb-3">
					<a href="index.php" class="">
						<h1 class="text-primary"><i class="fa fa-layer-group me-2"></i>Enoughchain</h3>
					</a>
				</div>
				<form action="" method="post">
				<select name="accountSelect" id="accountSelect" class="form-floating form-select mb-3" aria-label="Account select" required>
				  <option value="" selected>Select account</option>
				  {foreach from=$accounts key=account item=permissions}				     
					 <option value="{$account}">{$account} ({', '|implode:$permissions})</option>
				  {/foreach}				  
				</select>
				<div class="form-floating mb-4">
					<input name="privateKey" type="password" class="form-control" id="privateKey" placeholder="Private key" required>
					<label for="privateKey">Private key</label>
				</div>
				<button type="submit" class="btn btn-primary py-3 w-100 mb-4">Sign In</button>
				</form>
			</div>
		</div>
	</div>
</div>
<!-- Sign In End -->
