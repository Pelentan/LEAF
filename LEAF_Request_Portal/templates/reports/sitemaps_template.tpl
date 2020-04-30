<link rel="stylesheet" href="../libs/css/leaf.css" />

<!--{include file="../site_elements/generic_xhrDialog.tpl"}-->

<script>
	var sitemapOBJ;
    $(function() {
        sitemapOBJ = parseSitemapJSON();
        $.each(sitemapOBJ.cards, function(index, value){
			addCardToUI(value);
        });
        
        $("#sortable").sortable({
            revert: true
        });

    });

    function parseSitemapJSON(){
		sitemapJSON = $('span#sitemap-json').text();
    	result = jQuery.parseJSON(sitemapJSON);
        return result;
    }
    
    function buildSitemapJSON(){
    	return JSON.stringify(sitemapOBJ);
    }
        
    function addCardToUI(card){
    	    $('ul.usa-sidenav').append('<li class="usa-sidenav__item"><a href="">'+card.title+'</a></li>');
            $('div#sortable').append('<div class="leaf-sitemap-card" draggable="true"><h3>'+card.title+'</h3><p>'+card.description+'</p></div>');
    }
    
    function createGroup() {
        var dialog = createNewCardDialog();
        dialog.setTitle('Add New Card');
        dialog.setContent('<div><div role="heading">Card Title: </div><input aria-label="" id="card-title"></input><div role="heading" style="margin-top: 1rem;">Card Description: </div><input aria-label="Enter group name" id="card-description"></input><div role="heading" style="margin-top: 1rem;">Target Site Address: </div><input aria-label="" id="card-target"></input></div>');

        dialog.show();
        $('input:visible:first, select:visible:first').focus();
    }

    var dialog;
    $(function() {
		createNewCardDialog();
    });
   
    function createNewCardDialog() {
            var dialog = new dialogController('xhrDialog', 'xhr', 'loadIndicator', 'button_save', 'button_cancelchange');
       	 	dialog.setSaveHandler(function() {
            dialog.indicateBusy();
            console.log(sitemapOBJ.cards);
            var title = $("#xhr input#card-title").val();
            var description = $("#xhr input#card-description").val();
            var target = $("#xhr input#card-target").val();
            var order = sitemapOBJ.cards.length;
            var newCard = {title: title, description: description, target: target, order: order};
            sitemapOBJ.cards.push(newCard);
            addCardToUI(newCard);
            console.log(sitemapOBJ.cards);
            dialog.hide();
        });
	    $('#simplexhr').css({width: $(window).width() * .8, height: $(window).height() * .8});
        return dialog;
    }
    
    function save() { 
        $.ajax({
            type: 'GET',
            url: './api/system/reportTemplates/_sitemaps_template',
            success: function(res) {
                var newjson = "{\"saved\":1}";
                html = $.parseHTML( res.file );
               // var newFile = $(res.file).find('span#sitemap-json').replaceWith('other_element').end().get(0).outerHTML;
                var newFile = $(res.file);
                newFile.siblings('span#sitemap-json')[0].innerHTML = newjson;
                resultString = '';
                $.each(newFile, function( index, value ) {
                  if($.type(value.outerHTML) == 'string'){
                    resultString += value.outerHTML;
                  }
                });
                $.ajax({
                    type: 'POST',
                    data: {CSRFToken: '<!--{$CSRFToken}-->',
                           file: resultString},
                    url: './api/system/reportTemplates/_sitemaps_template',
                    success: function(res) {
                        if(res != null) {
                            alert(res);
                        }
                    }
                });
            },
            cache: false
        });
    }

</script>

<main id="main-content">

    <div class="grid-container">

        <div class="grid-row grid-gap">
            
            <div class="grid-col-3">
                <nav aria-label="Secondary navigation">
                    <h4>Phoenix VA Sitemap</h4>
                    <ul class="usa-sidenav">
                    </ul>
                    <div class="leaf-sidenav-bottomBtns">
                        <button class="usa-button leaf-btn-small">Move Up</button>
                        <button class="usa-button leaf-btn-small leaf-float-right">Move Down</button>
                    </div>
                </nav>
            </div>

            <div class="grid-col-9">

                <h1>Phoenix VA Sitemap</h1>
                <div id="sortable">
                </div>
                <div class="leaf-sitemap-addCard" onClick="createGroup();">
                    <h3>Tap To Add New Card</h3>
                </div>
                <div class="leaf-marginAll1rem leaf-clearBoth">
                    <button class="usa-button leaf-float-left" id="saveButton" onclick="buildSitemapJSON()">Save Sitemap</button>
                    <button class="usa-button usa-button--outline leaf-float-right">Delete Sitemap</button>
                </div>

            </div>
            
        </div>

    </div>
</main>
<span style="display: none;" id="sitemap-json">
    {
	"cards": [
		{
			"title": "Card One",
			"description": "This is a description",
			"target": "www.a.com",
			"order": 0
		},
		{
			"title": "Card Two",
			"description": "This is a description",
			"target": "www.b.com",
			"order": 1
		},
		{
			"title": "Card Three",
			"description": "This is a description",
			"target": "www.c.com",
			"order": 2
		}
	]
}
</span>
