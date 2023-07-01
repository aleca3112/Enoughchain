<div class="input-group mb-3">
	<select name="selectAccount" class="form-select" aria-label="selectAccount" required>
	  <option value="" selected>Select account</option>
	  {foreach from=$accounts key=account item=permissions}				     
		<option value="{$account}">{$account} ({', '|implode:$permissions})</option>
	  {/foreach}
	</select>
</div>
<div class="input-group mb-3">
	<span class="input-group-text" id="productID">Product ID:</span>
	<input class="form-control" type="number" name="productID" min="1" max="999999" required> 
</div>