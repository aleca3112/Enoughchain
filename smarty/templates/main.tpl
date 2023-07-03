<!-- Content Start -->
<div class="content open">
	<!-- Navbar Start -->
	<nav class="navbar navbar-expand bg-light navbar-light sticky-top px-4 py-0">
		<a href="index.php" class="">
			<h1 class="text-primary"><i class="fa fa-layer-group me-2"></i>Enoughchain</h1>
		</a>
		<div class="navbar-nav align-items-center ms-auto">
			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
					<span class="d-none d-lg-inline-flex">{if $logged}{$permissions} - {$account}{else}Anononymous{/if}</span>
				</a>
				<div class="dropdown-menu dropdown-menu-end bg-light border-0 rounded-0 rounded-bottom m-0">					
					{if $logged}
					<a href="logout.php" class="dropdown-item">Logout</a>
					{else}
					<a href="index.php?login=true" class="dropdown-item">Login</a>
					{/if}
				</div>
			</div>
		</div>
	</nav>
	<!-- Navbar End -->	
	
	<!-- Menu start -->
	{if isset($page)}
		<div class="container-fluid pt-4 px-4">
			<div class="text-center mb-3">
				<h2 class="text-primary "><i class="fa {$pageFa} me-2"></i>{$pageTitle}</h2>
			</div>
			<form action="" method="post" class="row g-1 mx-auto col-10 col-md-8 col-lg-6">
				{include file="{$page}"}
				<div class="input-group mb-3 gap-2">
					<div class="col-auto">
						<a class="btn btn-secondary" href="index.php" role="button">Back</a>
					</div>
					<div class="col-auto">
						<button type="submit" class="btn btn-primary">Confirm</button>
					</div>
				</div>
				<div class="input-group mb-3">
				  <textarea class="form-control" id="resultTextArea" rows="10" readonly >{$result}</textarea>
				</div>
			</form>
		</div>
	{else}
		{foreach from=$operations key=key item=operation name=name}
		  {if $smarty.foreach.name.index % 4 === 0}
			<div class="container-fluid pt-4 px-4">
				<div class="row g-1">
		  {/if}
				  <div class="col-sm-9 col-xl-3">
					<div class="bg-light rounded d-flex align-items-center justify-content-between p-4 card" style="width: 18rem;">
						<i class="fa {$operation->fa} fa-3x text-primary"></i>
						<div class="card-body">
							<h5 class="card-title">{$operation->title}</h5>
							<p class="card-text">{$operation->description}</p>
							<a href="?page={$key}" class="btn btn-primary">{$operation->title}</a>
					   </div>
					</div>
				  </div>
		  {if $smarty.foreach.name.index % 4 === 3 || $smarty.foreach.name.index +1 === count($operations)}
				</div>
			</div>
		  {/if}	  
		{/foreach}
	{/if}
	<!-- Menu End -->
	
</div>
<!-- Content End -->