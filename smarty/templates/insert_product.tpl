<div class="input-group mb-3">
  <span class="input-group-text" id="productName">Name:</span>
  <input type="text" class="form-control" name="productName" aria-label="Sizing example input" aria-describedby="productName" required>
</div>
<div class="input-group mb-3">
	<span class="input-group-text" id="ghgValue">GHG Value:</span>
	<input class="form-control" type="number" name="ghgValue" min="0" max="999999" required> 
</div>
<div class="input-group mb-3">
	<span class="input-group-text" id="qualityID">Quality ID:</span>
	<input class="form-control" type="number" name="qualityID" min="1" max="999999" required> 
</div>
<div class="input-group mb-3">
	<select name="sensorAccount" class="form-select" aria-label="sensorAccount" required>
	  <option value="" selected>Select sensor</option>
	  {foreach from=$sensorAccounts item=sensor}				     
		 <option value="{$sensor}">{$sensor}</option>
	  {/foreach}
	</select>
</div>