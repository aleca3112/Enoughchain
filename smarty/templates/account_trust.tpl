<div class="input-group mb-3">
	<select name="selectAccount" class="form-select" aria-label="selectAccount" required>
	  <option value="" selected>Select account</option>
	  {foreach from=$accounts key=account item=permissions}				     
		 <option value="{$account}">{$account} ({', '|implode:$permissions})</option>
	  {/foreach}
	</select>
</div>