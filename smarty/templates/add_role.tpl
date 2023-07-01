<div class="input-group mb-3">
	<select name="selectAccount" class="form-select" aria-label="selectAccount" required>
	  <option value="" selected>Select account to assign role to</option>
	  {foreach from=$accounts key=account item=permissions}				     
		 <option value="{$account}">{$account} ({', '|implode:$permissions})</option>
	  {/foreach}
	</select>
</div>
<div class="input-group mb-3">
	<select name="selectRole" class="form-select" aria-label="selectRole" required>
	  <option value="" selected>Select role</option>
	  <option value="producer">Producer</option>
	  <option value="trader">Trader</option>
	  <option value="sensor">Sensor</option>
	</select>
</div>