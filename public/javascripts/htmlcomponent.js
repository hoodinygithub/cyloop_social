    // Copyright 2007 www.flexcapacitor.com, www.drumbeatinsight.com 
    // Version 1.3.3
    
    // global array of html elements
    htmlControls = new Array();
    fcRelativeMovie = true;

	// add HTML element to the page
    function fcAddChild(o) {
    	var movie = fcGetMovieById(o.movieId);
    	htmlControls.movieId = o.movieId;
    	
    	if (o.type=="division") {
    		fcAddChildDivision(o);
    		movie.htmlCreationComplete(o.id);
    	}
    	else if (o.type=="iframe") {
    		fcAddChildIFrame(o);
    	}
    	else if (o.type=="editor") {
    		fcAddChildEditor(o);
    	}
    }
    
    // add division to the page
    function fcAddChildDivision(o) {
		fcGetIncludes(o.includesBefore);
		var newElement = document.createElement("div");
		newElement.id = o.id;
		newElement.name = o.name;
		newElement.movieId = o.movieId;
		
		newElement.style.position = o.position;
		fcSetSize(newElement,o.width,o.height);
		fcMoveElementTo(newElement,o.x,o.y);
		newElement.style.backgroundColor = "#" + o.backgroundColor;
		newElement.style.padding = "0px";
		newElement.style.margin = "0px";
		// always 0px - do not add a border to the container div tag
		// add a border in mxml or add a child div tag in the htmlText property
		// and add a border to that
		newElement.style.border = o.border;
		newElement.innerHTML = o.htmlText;
		
		document.body.appendChild(newElement);
		
		fcAddToGlobalArray(newElement, o.type);
		fcSetScrollPolicyById(o.id, o.htmlScrollPolicy);
		
		fcGetIncludes(o.includesAfter);
		
		if (!o.visible) {
			// fcHide(o.id,true,false);
		}
    }
    
    // add an editor to the page
    function fcAddChildEditor(o) {
    	// Add new editors here
		// There are three places to add new editor support.
		// here, getHTML, setHTML and if possible, call htmlCreationComplete
		// when the editor has been created
		// see FCKeditor_OnComplete for an example
		
		fcGetIncludes(o.includesBefore);
		var editorName = o.name + "Editor";
		var newElement = document.createElement("div");
		newElement.id = o.id;
		newElement.name = o.name;
		newElement.movieId = o.movieId;
		
		newElement.style.position = o.position;
		fcSetSize(newElement,o.width,o.height);
		fcMoveElementTo(newElement,o.x,o.y);
		newElement.style.backgroundColor = "#" + o.backgroundColor;
		newElement.style.padding = "0px";
		newElement.style.margin = "0px";
		newElement.style.border = o.border;
		
		var textareaElement = document.createElement("textarea");
		textareaElement.id = editorName;
		textareaElement.name = editorName;
		textareaElement.value = o.htmlText;
		fcSetSize(textareaElement,"100%","100%");
		newElement.appendChild(textareaElement);
		
		document.body.appendChild(newElement);
		fcSetScrollPolicyById(o.id, o.htmlScrollPolicy);
		
		// add additional editor support here
		if (o.editorType=="fckeditor") {
			// Create an instance of FCKeditor (using the target textarea as the
			// name).
			var oFCKeditor = new FCKeditor( editorName ) ;
			oFCKeditor.BasePath = o.editorPath;
			if (o.configPath) {
				oFCKeditor.Config["CustomConfigurationsPath"] = o.configPath +"?" + ( new Date() * 1 ) ;
			}
			oFCKeditor.Width = '100%' ;
			oFCKeditor.Height = '100%' ;
			oFCKeditor.ReplaceTextarea() ;
		}
		else if (o.editorType=="tinymce") {
		    var elm = document.getElementById(o.id);
		    var movie = fcGetMovieById(o.movieId);
		    movie.htmlCreationComplete(o.id);
		    
			if (typeof o.editorOptions == "string") {
				// crashes firefox???
				// tinyMCE.init({mode:"exact",theme:"simple"});
			}
			else {
				tinyMCE.init(o.editorOptions);
			}
			
			if (tinyMCE.getInstanceById(editorName) == null) {
				// cannot find editor sometimes. causes crash
				// tinyMCE.execCommand('mceAddControl', false, editorName);
			}
		}
		
		fcAddToGlobalArray(newElement, o.type);
		
		if (!o.visible) {
			// fcHide(o.id,true,false);
		}
		
    }
    
    // add iframe to the page
    function fcAddChildIFrame(o) {
		var newElement = document.createElement("iframe");
		newElement.id = o.id;
		newElement.name = o.name;
		newElement.movieId = o.movieId;
		newElement.width = o.width;
		newElement.height = o.height;		
		newElement.frameBorder = o.frameborder;
		newElement.style.position = o.position;
		fcSetSize(newElement,o.width,o.height);
		fcMoveElementTo(newElement,o.x,o.y);
		// newElement.style.backgroundColor = "transparent";
		// always 0px - do not add a border to the iframe itself
		// add a child div and add a border to that or add border in mxml
		newElement.style.border = o.border;
		newElement.src = o.source;
		
		// use innerHTML or DOM element creation methods to put content into
		// body
		document.body.appendChild(newElement);
		
		newElement.onload = new function() {
			// set a flag so the application knows the page is loaded
			// looking for a reliable method that works cross browser
			var movie = fcGetMovieById(o.movieId);
			movie.htmlCreationComplete(o.id);
		}
		
		newElement.onunload = new function() {
			// set a flag so the application knows the page is unloading
			var movie = fcGetMovieById(o.movieId);
			movie.htmlCreationComplete(o.id);
		}
		
		if (!o.visible) {
			// fcHide(o.id,true,false);
		}
		
    }
	
	// add to associative array
	function fcAddToGlobalArray(el, elementType) {
		var newElement = new Object();
		newElement.element = el;
		newElement.id = el.id;
		newElement.loaded = false;
		newElement.type = elementType;
		newElement.editor = "";
		if (elementType == "editor") {
			newElement.editor = document.getElementById(el.id + "Editor");
		}
		htmlControls[el.id] = newElement;
	}
	
	function fcCallScript(str) {
		try {
			var something = eval(str);
			return something;
		}
		catch(e) {
			return false;
		}
	}
	
	// handle when flash text field gets focus, text field in iframe is greedy
	function fcDefocus(movieId) {
		var movie = fcGetMovieById(movieId);
		window.focus();
		movie.focus();
	}
    
	// The FCKeditor_OnComplete function is a special function called everytime
	// an
	// editor instance is completely loaded and available for API interactions.
	function FCKeditor_OnComplete( editorInstance ) {
		var editor = document.getElementById( editorInstance.Name );
		if (editor) {
			htmlControls[editor.parentNode.id].loaded = true;
    		var movie = fcGetMovieById(editor.parentNode.movieId);
			movie.htmlCreationComplete(editor.parentNode.id);
		}
	}
	
	// gets the element by name
	function fcGetElement(id) {
		return document.getElementById(id);
	}
	
	// cannot get height of pages loaded from different domains
	// ie, page is hosted at www.yoursite.com and you load www.google.com will
	// fail with return value of -1
	// works in ff and ie. not tested in mac browsers -
	function fcGetElementHeight(id){
		var el = fcGetElement(id);
		moz = (document.getElementById && !document.all);
		
		if (el){
		
			// check the height value
			try {
			
				/** * return div height ** */
				if (el.nodeName.toLowerCase()=="div") {
					var scrollHeight = el.scrollHeight;
					var divHeight = el.style.height;
					divHeight = (scrollHeight > parseInt(divHeight)) ? scrollHeight : divHeight;
					return divHeight;
				}
				
				/** * return iframe height ** */
				// moz
				if (moz) {
					return el.contentDocument.body.scrollHeight;
				}
				else if (el.Document) {
					return el.Document.body.scrollHeight;
				}
			}
			catch(e)
			{
				// An error is raised if the IFrame domain != its container's
				// domain
				// alert('Error: ' + e.number + '; ' + e.description+'\nPossibly
				// - Cannot access because page domain does not equal container
				// domain');
				return -1;
			}
		}
	}

	// get property value
	function fcGetElementValue(id, elProperty){
		
		// if periods are in the name assume absolute path
		// otherwise assume element id
		if (id.indexOf('.')!=-1) {
			var newArr = id.split('.');
			var elValue = "";
			
			try {
				el = window;
				for (var i=0;i < newArr.length;i++) {
					el = el[newArr[i]];
				}
				return el;
			}
			catch (e) {
				// alert("Whoooops!! Cant find " + elId);
				// should return null or undefined here
				return -1;
			}
		}
		else {
			// try and get property value
			try {
				var el = fcGetElement(id);
				var elValue = el[elProperty];
				return elValue;
			}
			catch(e) {
				// alert("Error: Can't find " + elId + "." + elProperty);
				// should return null or undefined here
				return -1;
			}
		}
	}
	
	// get HTML content
	function fcGetHTML(id, elementType, editorType) {
		var el = fcGetElement(id);
		if (el!=null) {
			
			if (elementType =="division") {
				return el.innerHTML;
			}
			else if (elementType == "editor") {
				var oEditor;
				
					// add additional editor support here
				if (editorType=="fckeditor") {
					if ( typeof( FCKeditorAPI ) != 'undefined' ) {
						oEditor = FCKeditorAPI.GetInstance( id + "Editor" );
						if ( oEditor )	{
							// Get the current text in the editor.
							return oEditor.GetXHTML();
						}
					}
				}
				else if (editorType=="tinymce") {
					return tinyMCE.getContent(id);
				}
				
				
			}
		}
		return "";
	}
	
	function fcGetIncludes(includes) {
		var len = includes.length;
		// var head = document.getElementsByTagName("head");
		// sometimes this doesn't work. possibly browser issues. in those cases
		// add includes directly to the html page
		for (var i=0;i<len;i++) {
			var el = document.createElement("script");
			// el.onload = onload2;
			el.setAttribute("src",includes[i]);
			el.setAttribute("type","text/javascript");
			document.body.appendChild(el);
		}
	}

	// get reference to the flash movie
	function fcGetMovieById(id) {
		if (navigator.appName.indexOf ("Microsoft") !=-1) {
			return window[id];
		} else {
			return window.document[id];
		}
	}
	
	// hide element by name
	// set height of content to 0px so the
	// flash context menu appears in the right location
	function fcHide(id, hideOffscreen, offscreenOffset) {
		var el = fcGetElement(id);
		if (hideOffscreen) {
			el.style.width = "0px";
			el.style.height = "0px";
		}
		el.style.visibility = "hidden";
	}
	
   // move element to new location 
   function fcMoveElementTo(el,x,y) {
      var movie = fcGetMovieById(el.movieId); 
      if (fcRelativeMovie) { 
         el.style.left = parseInt(x) + fcFindPosition(movie)[0] + "px"; 
         el.style.top = parseInt(y) + fcFindPosition(movie)[1] + "px"; 
      } 
      else { 
         el.style.left = parseInt(x) + "px"; 
         el.style.top = parseInt(y) + "px"; 
      } 
   }

    // forces redraw
	function fcRefresh(id) {
		var el = fcGetElement(id);
		el.style.cssText = el.style.cssText;
	}
	
	// remove
	function fcRemove(id) {
		// fcHide(id, true);
		var el = fcGetElement(id);
		var elParent = el.parentNode;
		elParent.removeChild(el);
	}
    
	// set document title
    function fcSetDocumentTitle(title) {
        window.document.title = title;
        return 1;
    }
	
	// set HTML content
	function fcSetHTML(id, htmlText, elementType, editorType) {
		var el = fcGetElement(id);
		if (el!=null) {
		
			if (elementType =="division") {
				el.innerHTML = htmlText;
			}
			else if (elementType == "editor") {
				var oEditor;
				
				// add additional editor support here
				if (editorType == "fckeditor") {
					if ( typeof( FCKeditorAPI ) != 'undefined' ) {
						oEditor = FCKeditorAPI.GetInstance( id + "Editor" );
						if ( oEditor )	{
							// Set the text in the editor.
							oEditor.SetHTML( htmlText ) ;
						}
					}
				}
				else if (editorType=="tinymce") {
					var editor = tinyMCE.getInstanceById(id+"Editor");
					editor.setHTML(htmlText);
				}
			}
		}
	}
	
   // set position
   function fcSetPosition(id,x,y) { 
      var el = fcGetElement(id); 
      var movie = fcGetMovieById(fcHTMLControls[id].movieId); 
      if (fcHTMLControls[id].popUp == true ) { return } 
       
      // LEFT
      if (x != undefined) { 
         el.style.left = parseInt(x) + fcFindPosition(movie)[0] + "px"; 
      } 
      // TOP
      if (y != undefined) { 
         el.style.top = parseInt(y) + fcFindPosition(movie)[1] + "px"; 
      } 
   }

   // finds the absolute position of the swf movie 
   function fcFindPosition(obj) { 
      var left = obj.offsetLeft; 
      var top = obj.offsetTop; 
      if (obj.offsetParent) { 
         var parentPos = this.fcFindPosition(obj.offsetParent); 
         if (parentPos[0]) left += parentPos[0]; 
           if (parentPos[1]) top += parentPos[1]; 
       } 
      return [left,top]; 
    }

    // set scroll policy of element
	function fcSetScrollPolicy(el, overflow) {
		if (overflow != "resize") {
			el.style.overflow = overflow;
		}
	}
	
	// set scroll policy of element by id
	function fcSetScrollPolicyById(id, overflow) {
		var el = fcGetElement(id);
		
		// setting this to anything other than auto in ff fails it
		if (overflow != "resize") {
			el.style.overflow = overflow;
		}
	}
	
	// set size
	function fcSetSize(el,w,h) {
		// WIDTH
		if (w != undefined) {
			// if width is a percentage pass in the string as is
			if (String(w).indexOf("%")!=-1) {
				el.style.width = w;
			}
			else {
				el.style.width = parseInt(w) + "px";
			}
		}
		
		// HEIGHT
		if (h!=undefined) {
			if (String(h).indexOf("%")!=-1) {
				el.style.height = h;
			}
			else {
				el.style.height = parseInt(h) + "px"; 
			}
		}
	}
	
   // set size called by id 
   function fcSetSizeByValue(id,w,h) { 
      var el = fcGetElement(id); 
      if (el.style.display=="none") { return; } 
      if (fcHTMLControls[id].popUp == true ) { return } 
      
      if (String(w)!="null" && String(w)!="undefined" && String(w)!="") { 
         // if width is a percentage pass in the string as is 
         if (String(w).indexOf("%")!=-1) { 
            el.style.width = w; 
         } 
         else { 
            el.style.width = parseInt(w) + "px"; 
         } 
      } 
      
      if (String(h)!="null" && String(h)!="undefined" && String(h)!="") { 
         if (String(h).indexOf("%")!=-1) { 
            el.style.height = h; 
         } 
         else { 
            el.style.height = parseInt(h) + "px"; 
         } 
      } 
   }

	// set iframe location
	function fcSetSource(id,source){
		var el = fcGetElement(id);
		el.src = source;
	}
	
	// show element by name
	function fcShow(id, hideOffscreen, left, width, height) {
		var el = fcGetElement(id);
		el.style.visibility = "visible";
		if (hideOffscreen) {
			el.style.width = parseInt(width) + "px";
			el.style.height = parseInt(height) + "px";
		}
	}

	function fcFlexOnload(movieId) {
		// calling callback is unreliable - movie may not be loaded yet
		// movie.onLoadComplete();
		htmlControls.pageLoaded = "true";
	}