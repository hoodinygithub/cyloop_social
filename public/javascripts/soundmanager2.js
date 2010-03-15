
function SoundManager(smURL,smID){this.flashVersion=8;this.debugMode=false;this.useConsole=true;this.consoleOnly=false;this.waitForWindowLoad=false;this.nullURL='data/null.mp3';this.allowPolling=true;this.defaultOptions={'autoLoad':false,'stream':true,'autoPlay':false,'onid3':null,'onload':null,'whileloading':null,'onplay':null,'onpause':null,'onresume':null,'whileplaying':null,'onstop':null,'onfinish':null,'onbeforefinish':null,'onbeforefinishtime':5000,'onbeforefinishcomplete':null,'onjustbeforefinish':null,'onjustbeforefinishtime':200,'multiShot':true,'position':null,'pan':0,'volume':100};this.flash9Options={usePeakData:false,useWaveformData:false,useEQData:false};this.flashBlockHelper={enabled:false,message:['<div id="sm2-flashblock" style="position:fixed;left:0px;top:0px;width:100%;min-height:24px;z-index:9999;background:#666;color:#fff;font-family:helvetica,verdana,arial;font-size:11px;border-bottom:1px solid #333;opacity:0.95">','<div style="float:right;display:inline;margin-right:0.5em;color:#999;line-height:24px">[<a href="#noflashblock" onclick="document.getElementById(\'sm2-flashblock\').style.display=\'none\'" title="Go away! :)" style="color:#fff;text-decoration:none">x</a>]</div>','<div id="sm2-flashmovie" style="float:left;display:inline;margin-left:0.5em;margin-right:0.5em"><!-- [flash] --></div>','<div style="padding-left:0.5em;padding-right:0.5em;line-height:24px">Using Flashblock? Please right-click the icon and "<b>allow flash from this site</b>" to enable sound/audio features, and then reload this page.</div>','</div>']};var _s=this;this.version=null;this.versionNumber='V2.78a.20080920';this.movieURL=null;this.url=null;this.altURL=null;this.swfLoaded=false;this.enabled=false;this.o=null;this.id=(smID||'sm2movie');this.oMC=null;this.sounds=[];this.soundIDs=[];this.muted=false;this.isIE=(navigator.userAgent.match(/MSIE/i));this.isSafari=(navigator.userAgent.match(/safari/i));this.isGecko=(navigator.userAgent.match(/gecko/i));this.debugID='soundmanager-debug';this._debugOpen=true;this._didAppend=false;this._appendSuccess=false;this._didInit=false;this._disabled=false;this._windowLoaded=false;this._hasConsole=(typeof console!='undefined'&&typeof console.log!='undefined');this._debugLevels=['log','info','warn','error'];this._defaultFlashVersion=8;this.features={peakData:false,waveformData:false,eqData:false};this.sandbox={'type':null,'types':{'remote':'remote (domain-based) rules','localWithFile':'local with file access (no internet access)','localWithNetwork':'local with network (internet access only, no local access)','localTrusted':'local, trusted (local + internet access)'},'description':null,'noRemote':null,'noLocal':null};this._setVersionInfo=function(){if(_s.flashVersion!=8&&_s.flashVersion!=9){alert('soundManager.flashVersion must be 8 or 9. "'+_s.flashVersion+'" is invalid. Reverting to '+_s._defaultFlashVersion+'.');_s.flashVersion=_s._defaultFlashVersion;}
_s.version=_s.versionNumber+(_s.flashVersion==9?' (AS3/Flash 9)':' (AS2/Flash 8)');_s.movieURL=(_s.flashVersion==8?'soundmanager2.swf':'soundmanager2_flash9.swf');_s.features.peakData=_s.features.waveformData=_s.features.eqData=(_s.flashVersion==9);}
this._overHTTP=(document.location?document.location.protocol.match(/http/i):null);this._waitingforEI=false;this._initPending=false;this._tryInitOnFocus=(this.isSafari&&typeof document.hasFocus=='undefined');this._isFocused=(typeof document.hasFocus!='undefined'?document.hasFocus():null);this._okToDisable=!this._tryInitOnFocus;this.useAltURL=!this._overHTTP;var flashCPLink='http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager04.html';this.supported=function(){return(_s._didInit&&!_s._disabled);};this.getMovie=function(smID){return _s.isIE?window[smID]:(_s.isSafari?document.getElementById(smID)||document[smID]:document.getElementById(smID));};this.loadFromXML=function(sXmlUrl){try{_s.o._loadFromXML(sXmlUrl);}catch(e){_s._failSafely();return true;};};this.createSound=function(oOptions){if(!_s._didInit)throw new Error('soundManager.createSound(): Not loaded yet - wait for soundManager.onload() before calling sound-related methods');if(arguments.length==2){oOptions={'id':arguments[0],'url':arguments[1]};};var thisOptions=_s._mergeObjects(oOptions);if(_s._idCheck(thisOptions.id,true)){return _s.sounds[thisOptions.id];};_s.sounds[thisOptions.id]=new SMSound(thisOptions);_s.soundIDs[_s.soundIDs.length]=thisOptions.id;if(_s.flashVersion==8){_s.o._createSound(thisOptions.id,thisOptions.onjustbeforefinishtime);}else{_s.o._createSound(thisOptions.id,thisOptions.url,thisOptions.onjustbeforefinishtime,thisOptions.usePeakData,thisOptions.useWaveformData,thisOptions.useEQData);};if(thisOptions.autoLoad||thisOptions.autoPlay)window.setTimeout(function(){_s.sounds[thisOptions.id].load(thisOptions);},20);if(thisOptions.autoPlay){if(_s.flashVersion==8){_s.sounds[thisOptions.id].playState=1;}else{_s.sounds[thisOptions.id].play();}}
return _s.sounds[thisOptions.id];};this.destroySound=function(sID,bFromSound){if(!_s._idCheck(sID))return false;for(var i=0;i<_s.soundIDs.length;i++){if(_s.soundIDs[i]==sID){_s.soundIDs.splice(i,1);continue;};};_s.sounds[sID].unload();if(!bFromSound){_s.sounds[sID].destruct();};delete _s.sounds[sID];};this.load=function(sID,oOptions){if(!_s._idCheck(sID))return false;_s.sounds[sID].load(oOptions);};this.unload=function(sID){if(!_s._idCheck(sID))return false;_s.sounds[sID].unload();};this.play=function(sID,oOptions){if(!_s._idCheck(sID)){if(typeof oOptions!='Object')oOptions={url:oOptions};if(oOptions&&oOptions.url){oOptions.id=sID;_s.createSound(oOptions);}else{return false;};};_s.sounds[sID].play(oOptions);};this.start=this.play;this.setPosition=function(sID,nMsecOffset){if(!_s._idCheck(sID))return false;_s.sounds[sID].setPosition(nMsecOffset);};this.stop=function(sID){if(!_s._idCheck(sID))return false;_s.sounds[sID].stop();};this.stopAll=function(){for(var oSound in _s.sounds){if(_s.sounds[oSound]instanceof SMSound)_s.sounds[oSound].stop();};};this.pause=function(sID){if(!_s._idCheck(sID))return false;_s.sounds[sID].pause();};this.resume=function(sID){if(!_s._idCheck(sID))return false;_s.sounds[sID].resume();};this.togglePause=function(sID){if(!_s._idCheck(sID))return false;_s.sounds[sID].togglePause();};this.setPan=function(sID,nPan){if(!_s._idCheck(sID))return false;_s.sounds[sID].setPan(nPan);};this.setVolume=function(sID,nVol){if(!_s._idCheck(sID))return false;_s.sounds[sID].setVolume(nVol);};this.mute=function(sID){if(typeof sID!='string')sID=null;if(!sID){var o=null;for(var i=_s.soundIDs.length;i--;){_s.sounds[_s.soundIDs[i]].mute();}
_s.muted=true;}else{if(!_s._idCheck(sID))return false;_s.sounds[sID].mute();}};this.unmute=function(sID){if(typeof sID!='string')sID=null;if(!sID){var o=null;for(var i=_s.soundIDs.length;i--;){_s.sounds[_s.soundIDs[i]].unmute();}
_s.muted=false;}else{if(!_s._idCheck(sID))return false;_s.sounds[sID].unmute();}};this.setPolling=function(bPolling){if(!_s.o||!_s.allowPolling)return false;_s.o._setPolling(bPolling);};this.disable=function(bUnload){if(_s._disabled)return false;if(!bUnload&&_s.flashBlockHelper.enabled){_s.handleFlashBlock();}
_s._disabled=true;for(var i=_s.soundIDs.length;i--;){_s._disableObject(_s.sounds[_s.soundIDs[i]]);};_s.initComplete();_s._disableObject(_s);};this.handleFlashBlock=function(bForce){function showNagbar(){var o=document.getElementById('sm2-flashblock');if(!o){try{var oC=document.getElementById('sm2-container');if(oC){oC.parentNode.removeChild(oC);}
var oBar=document.createElement('div');oBar.innerHTML=_s.flashBlockHelper.message.join('').replace('<!-- [flash] -->',_s._html);_s._getDocument().appendChild(oBar);window.setTimeout(function(){var oIco=document.getElementById('sm2-flashmovie').getElementsByTagName('div')[0];if(oIco){oIco.style.background='url(chrome://flashblock/skin/flash-disabled-16.png) 0px 0px no-repeat';oIco.style.border='none';oIco.style.minWidth='';oIco.style.minHeight='';oIco.style.width='16px';oIco.style.height='16px';oIco.style.marginTop='4px';oIco.onmouseover=null;oIco.onmouseout=null;oIco.onclick=null;document.getElementById('sm2-flashmovie').onclick=oIco.onclick;}else{return false;}},1);}catch(e){return false;}}else{o.style.display='block';};this.onload=null;};if(bForce){showNagbar();return false;};if(!_s.isGecko)return false;if(window.location.toString().match(/\#noflashblock/i)){return false;}
var chromeURL='chrome://flashblock/skin/flash-disabled-16.png';var img=new Image();img.style.position='absolute';img.style.left='-256px';img.style.top='-256px';img.onload=showNagbar;img.onerror=function(){this.onerror=null;}
img.src=chromeURL;_s._getDocument().appendChild(img);};this.getSoundById=function(sID,suppressDebug){if(!sID)throw new Error('SoundManager.getSoundById(): sID is null/undefined');var result=_s.sounds[sID];if(!result&&!suppressDebug){};return result;};this.onload=function(){};this.onerror=function(){};this._idCheck=this.getSoundById;this._disableObject=function(o){for(var oProp in o){if(typeof o[oProp]=='function'&&typeof o[oProp]._protected=='undefined')o[oProp]=function(){return false;};};oProp=null;};this._failSafely=function(){var fpgssTitle='You may need to whitelist this location/domain eg. file:///C:/ or C:/ or mysite.com, or set ALWAYS ALLOW under the Flash Player Global Security Settings page. The latter is probably less-secure.';var flashCPL='<a href="'+flashCPLink+'" title="'+fpgssTitle+'">view/edit</a>';var FPGSS='<a href="'+flashCPLink+'" title="Flash Player Global Security Settings">FPGSS</a>';if(!_s._disabled){_s.disable();};};this._normalizeMovieURL=function(smURL){if(smURL){if(smURL.match(/\.swf/)){smURL=smURL.substr(0,smURL.lastIndexOf('.swf'));}
if(smURL.lastIndexOf('/')!=smURL.length-1){smURL=smURL+'/';}}
return(smURL&&smURL.lastIndexOf('/')!=-1?smURL.substr(0,smURL.lastIndexOf('/')+1):'./')+_s.movieURL;};this._getDocument=function(){return(document.body?document.body:(document.documentElement?document.documentElement:document.getElementsByTagName('div')[0]));};this._getDocument._protected=true;this._createMovie=function(smID,smURL){if(_s._didAppend&&_s._appendSuccess)return false;if(window.location.href.indexOf('debug=1')+1)_s.debugMode=true;_s._didAppend=true;_s._setVersionInfo();var remoteURL=(smURL?smURL:_s.url);var localURL=(_s.altURL?_s.altURL:remoteURL);_s.url=_s._normalizeMovieURL(_s._overHTTP?remoteURL:localURL);smURL=_s.url;var htmlEmbed='<embed name="'+smID+'" id="'+smID+'" src="'+smURL+'" width="1" height="1" quality="high" allowScriptAccess="always" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash"></embed>';var htmlObject='<object id="'+smID+'" data="'+smURL+'" type="application/x-shockwave-flash" width="1" height="1"><param name="movie" value="'+smURL+'" /><param name="AllowScriptAccess" value="always" /><!-- --></object>';html=(!_s.isIE?htmlEmbed:htmlObject);_s._html=html;var toggleElement='<div id="'+_s.debugID+'-toggle" style="position:fixed;_position:absolute;right:0px;bottom:0px;_top:0px;width:1.2em;height:1.2em;line-height:1.2em;margin:2px;padding:0px;text-align:center;border:1px solid #999;cursor:pointer;background:#fff;color:#333;z-index:706" title="Toggle SM2 debug console" onclick="soundManager._toggleDebug()">-</div>';var debugHTML='<div id="'+_s.debugID+'" style="display:'+(_s.debugMode&&((!_s._hasConsole||!_s.useConsole)||(_s.useConsole&&_s._hasConsole&&!_s.consoleOnly))?'block':'none')+';opacity:0.85"></div>';var appXHTML='soundManager._createMovie(): appendChild/innerHTML set failed. May be app/xhtml+xml DOM-related.';var sHTML='<div id="sm2-container" style="position:absolute;left:-256px;top:-256px;width:1px;height:1px" class="movieContainer">'+html+'</div>'+(_s.debugMode&&((!_s._hasConsole||!_s.useConsole)||(_s.useConsole&&_s._hasConsole&&!_s.consoleOnly))&&!document.getElementById(_s.debugID)?'x'+debugHTML+toggleElement:'');var oTarget=_s._getDocument();if(oTarget){_s.oMC=document.createElement('div');_s.oMC.id='sm2-container';_s.oMC.className='movieContainer';_s.oMC.style.position='absolute';_s.oMC.style.left='-256px';_s.oMC.style.width='1px';_s.oMC.style.height='1px';try{oTarget.appendChild(_s.oMC);_s.oMC.innerHTML=html;_s._appendSuccess=true;}catch(e){throw new Error(appXHTML);};if(!document.getElementById(_s.debugID)&&((!_s._hasConsole||!_s.useConsole)||(_s.useConsole&&_s._hasConsole&&!_s.consoleOnly))){var oDebug=document.createElement('div');oDebug.id=_s.debugID;oDebug.style.display=(_s.debugMode?'block':'none');if(_s.debugMode){try{var oD=document.createElement('div');oTarget.appendChild(oD);oD.innerHTML=toggleElement;}catch(e){throw new Error(appXHTML);};};oTarget.appendChild(oDebug);};oTarget=null;};};this._writeDebug=function(sText,sType,bTimestamp){};this._writeDebug._protected=true;this._writeDebugAlert=function(sText){alert(sText);};this._toggleDebug=function(){var o=document.getElementById(_s.debugID);var oT=document.getElementById(_s.debugID+'-toggle');if(!o)return false;if(_s._debugOpen){oT.innerHTML='+';o.style.display='none';}else{oT.innerHTML='-';o.style.display='block';};_s._debugOpen=!_s._debugOpen;};this._toggleDebug._protected=true;this._debug=function(){};this._mergeObjects=function(oMain,oAdd){var o1={};for(var i in oMain){o1[i]=oMain[i];}
var o2=(typeof oAdd=='undefined'?_s.defaultOptions:oAdd);for(var o in o2){if(typeof o1[o]=='undefined')o1[o]=o2[o];};return o1;};this.createMovie=function(sURL){if(sURL)_s.url=sURL;_s._initMovie();};this.go=this.createMovie;this._initMovie=function(){if(_s.o)return false;_s.o=_s.getMovie(_s.id);if(!_s.o){_s._createMovie(_s.id,_s.url);_s.o=_s.getMovie(_s.id);};};this.waitForExternalInterface=function(){if(_s._waitingForEI)return false;_s._waitingForEI=true;if(_s._tryInitOnFocus&&!_s._isFocused){return false;};setTimeout(function(){if(!_s._didInit){if(!_s._overHTTP){};};if(!_s._didInit&&_s._okToDisable)_s._failSafely();},750);};this.handleFocus=function(){if(_s._isFocused||!_s._tryInitOnFocus)return true;_s._okToDisable=true;_s._isFocused=true;if(_s._tryInitOnFocus){window.removeEventListener('mousemove',_s.handleFocus,false);};_s._waitingForEI=false;setTimeout(_s.waitForExternalInterface,500);if(window.removeEventListener){window.removeEventListener('focus',_s.handleFocus,false);}else if(window.detachEvent){window.detachEvent('onfocus',_s.handleFocus);};};this.initComplete=function(){if(_s._didInit)return false;_s._didInit=true;if(_s._disabled){_s.onerror.apply(window);return false;};if(_s.waitForWindowLoad&&!_s._windowLoaded){if(window.addEventListener){window.addEventListener('load',_s.initUserOnload,false);}else if(window.attachEvent){window.attachEvent('onload',_s.initUserOnload);};return false;}else{if(_s.waitForWindowLoad&&_s._windowLoaded){};_s.initUserOnload();};};this.initUserOnload=function(){try{_s.onload.apply(window);}catch(e){setTimeout(function(){throw new Error(e)},20);return false;};};this.init=function(){_s._initMovie();if(_s._didInit){return false;};if(window.removeEventListener){window.removeEventListener('load',_s.beginDelayedInit,false);}else if(window.detachEvent){window.detachEvent('onload',_s.beginDelayedInit);};try{_s.o._externalInterfaceTest(false);_s.setPolling(true);if(!_s.debugMode)_s.o._disableDebug();_s.enabled=true;}catch(e){_s._failSafely();_s.initComplete();return false;};_s.initComplete();};this.beginDelayedInit=function(){_s._windowLoaded=true;setTimeout(_s.waitForExternalInterface,500);setTimeout(_s.beginInit,20);};this.beginInit=function(){if(_s._initPending)return false;_s.createMovie();_s._initMovie();_s._initPending=true;return true;};this.domContentLoaded=function(){if(document.removeEventListener)document.removeEventListener('DOMContentLoaded',_s.domContentLoaded,false);_s.go();};this._externalInterfaceOK=function(){if(_s.swfLoaded)return false;_s.swfLoaded=true;_s._tryInitOnFocus=false;if(_s.isIE){setTimeout(_s.init,100);}else{_s.init();};};this._setSandboxType=function(sandboxType){var sb=_s.sandbox;sb.type=sandboxType;sb.description=sb.types[(typeof sb.types[sandboxType]!='undefined'?sandboxType:'unknown')];if(sb.type=='localWithFile'){sb.noRemote=true;sb.noLocal=false;}else if(sb.type=='localWithNetwork'){sb.noRemote=false;sb.noLocal=true;}else if(sb.type=='localTrusted'){sb.noRemote=false;sb.noLocal=false;};};this.destruct=function(){_s.disable(true);};function SMSound(oOptions){var _t=this;this.sID=oOptions.id;this.url=oOptions.url;this.options=_s._mergeObjects(oOptions);this.instanceOptions=this.options;this._debug=function(){if(_s.debugMode){var stuff=null;var msg=[];var sF=null;var sfBracket=null;var maxLength=64;for(stuff in _t.options){if(_t.options[stuff]!=null){if(_t.options[stuff]instanceof Function){sF=_t.options[stuff].toString();sF=sF.replace(/\s\s+/g,' ');sfBracket=sF.indexOf('{');msg[msg.length]=' '+stuff+': {'+sF.substr(sfBracket+1,(Math.min(Math.max(sF.indexOf('\n')-1,maxLength),maxLength))).replace(/\n/g,'')+'... }';}else{msg[msg.length]=' '+stuff+': '+_t.options[stuff];};};};};};this._debug();this.id3={};this.resetProperties=function(bLoaded){_t.bytesLoaded=null;_t.bytesTotal=null;_t.position=null;_t.duration=null;_t.durationEstimate=null;_t.loaded=false;_t.loadSuccess=null;_t.playState=0;_t.paused=false;_t.readyState=0;_t.muted=false;_t.didBeforeFinish=false;_t.didJustBeforeFinish=false;_t.instanceOptions={};_t.instanceCount=0;_t.peakData={left:0,right:0};_t.waveformData=[];_t.eqData=[];};_t.resetProperties();this.load=function(oOptions){if(typeof oOptions!='undefined'){_t.instanceOptions=_s._mergeObjects(oOptions);}else{var oOptions=_t.options;_t.instanceOptions=oOptions;}
if(typeof _t.instanceOptions.url=='undefined')_t.instanceOptions.url=_t.url;if(_t.instanceOptions.url==_t.url&&_t.readyState!=0&&_t.readyState!=2){return false;}
_t.loaded=false;_t.loadSuccess=null;_t.readyState=1;_t.playState=(oOptions.autoPlay?1:0);try{if(_s.flashVersion==8){_s.o._load(_t.sID,_t.instanceOptions.url,_t.instanceOptions.stream,_t.instanceOptions.autoPlay,(_t.instanceOptions.whileloading?1:0));}else{_s.o._load(_t.sID,_t.instanceOptions.url,_t.instanceOptions.stream?true:false,_t.instanceOptions.autoPlay?true:false);};}catch(e){_s.onerror();_s.disable();};};this.unload=function(){if(_t.readyState!=0){_t.setPosition(0);_s.o._unload(_t.sID,_s.nullURL);_t.resetProperties();}};this.destruct=function(){_s.o._destroySound(_t.sID);_s.destroySound(_t.sID,true);}
this.play=function(oOptions){if(!oOptions)oOptions={};_t.instanceOptions=_s._mergeObjects(oOptions,_t.instanceOptions);_t.instanceOptions=_s._mergeObjects(_t.instanceOptions,_t.options);if(_t.playState==1){var allowMulti=_t.instanceOptions.multiShot;if(!allowMulti){return false;}else{};};if(!_t.loaded){if(_t.readyState==0){_t.instanceOptions.stream=true;_t.instanceOptions.autoPlay=true;_t.load(_t.instanceOptions);}else if(_t.readyState==2){return false;}else{};}else{};if(_t.paused){_t.resume();}else{_t.playState=1;if(!_t.instanceCount||_s.flashVersion==9)_t.instanceCount++;_t.position=(typeof _t.instanceOptions.position!='undefined'&&!isNaN(_t.instanceOptions.position)?_t.instanceOptions.position:0);if(_t.instanceOptions.onplay)_t.instanceOptions.onplay.apply(_t);_t.setVolume(_t.instanceOptions.volume);_t.setPan(_t.instanceOptions.pan);_s.o._start(_t.sID,_t.instanceOptions.loop||1,(_s.flashVersion==9?_t.position:_t.position/1000));};};this.start=this.play;this.stop=function(bAll){if(_t.playState==1){_t.playState=0;_t.paused=false;if(_t.instanceOptions.onstop)_t.instanceOptions.onstop.apply(_t);_s.o._stop(_t.sID,bAll);_t.instanceCount=0;_t.instanceOptions={};};};this.setPosition=function(nMsecOffset){_t.instanceOptions.position=nMsecOffset;_s.o._setPosition(_t.sID,(_s.flashVersion==9?_t.instanceOptions.position:_t.instanceOptions.position/1000),(_t.paused||!_t.playState));};this.pause=function(){if(_t.paused)return false;_t.paused=true;_s.o._pause(_t.sID);if(_t.instanceOptions.onpause)_t.instanceOptions.onpause.apply(_t);};this.resume=function(){if(!_t.paused)return false;_t.paused=false;_s.o._pause(_t.sID);if(_t.instanceOptions.onresume)_t.instanceOptions.onresume.apply(_t);};this.togglePause=function(){if(!_t.playState){_t.play({position:(_s.flashVersion==9?_t.position:_t.position/1000)});return false;};if(_t.paused){_t.resume();}else{_t.pause();};};this.setPan=function(nPan){if(typeof nPan=='undefined')nPan=0;_s.o._setPan(_t.sID,nPan);_t.instanceOptions.pan=nPan;};this.setVolume=function(nVol){if(typeof nVol=='undefined')nVol=100;_s.o._setVolume(_t.sID,(_s.muted&&!_t.muted)||_t.muted?0:nVol);_t.instanceOptions.volume=nVol;};this.mute=function(){_t.muted=true;_s.o._setVolume(_t.sID,0);};this.unmute=function(){_t.muted=false;_s.o._setVolume(_t.sID,typeof _t.instanceOptions.volume!='undefined'?_t.instanceOptions.volume:_t.options.volume);};this._whileloading=function(nBytesLoaded,nBytesTotal,nDuration){_t.bytesLoaded=nBytesLoaded;_t.bytesTotal=nBytesTotal;_t.duration=Math.floor(nDuration);_t.durationEstimate=parseInt((_t.bytesTotal/_t.bytesLoaded)*_t.duration);if(_t.readyState!=3&&_t.instanceOptions.whileloading)_t.instanceOptions.whileloading.apply(_t);};this._onid3=function(oID3PropNames,oID3Data){var oData=[];for(var i=0,j=oID3PropNames.length;i<j;i++){oData[oID3PropNames[i]]=oID3Data[i];};_t.id3=_s._mergeObjects(_t.id3,oData);if(_t.instanceOptions.onid3)_t.instanceOptions.onid3.apply(_t);};this._whileplaying=function(nPosition,oPeakData,oWaveformData,oEQData){if(isNaN(nPosition)||nPosition==null)return false;_t.position=nPosition;if(_t.instanceOptions.usePeakData&&typeof oPeakData!='undefined'&&oPeakData){_t.peakData={left:oPeakData.leftPeak,right:oPeakData.rightPeak};};if(_t.instanceOptions.useWaveformData&&typeof oWaveformData!='undefined'&&oWaveformData){_t.waveformData=oWaveformData;};if(_t.instanceOptions.useEQData&&typeof oEQData!='undefined'&&oEQData){_t.eqData=oEQData;};if(_t.playState==1){if(_t.instanceOptions.whileplaying)_t.instanceOptions.whileplaying.apply(_t);if(_t.loaded&&_t.instanceOptions.onbeforefinish&&_t.instanceOptions.onbeforefinishtime&&!_t.didBeforeFinish&&_t.duration-_t.position<=_t.instanceOptions.onbeforefinishtime){_t._onbeforefinish();};};};this._onload=function(bSuccess){bSuccess=(bSuccess==1?true:false);_t.loaded=bSuccess;_t.loadSuccess=bSuccess;_t.readyState=bSuccess?3:2;if(_t.instanceOptions.onload){_t.instanceOptions.onload.apply(_t);};};this._onbeforefinish=function(){if(!_t.didBeforeFinish){_t.didBeforeFinish=true;if(_t.instanceOptions.onbeforefinish){_t.instanceOptions.onbeforefinish.apply(_t);}};};this._onjustbeforefinish=function(msOffset){if(!_t.didJustBeforeFinish){_t.didJustBeforeFinish=true;if(_t.instanceOptions.onjustbeforefinish){_t.instanceOptions.onjustbeforefinish.apply(_t);}};};this._onfinish=function(){_t.playState=0;_t.paused=false;if(_t.instanceOptions.onfinish){_t.instanceOptions.onfinish.apply(_t);}
if(_t.instanceOptions.onbeforefinishcomplete)_t.instanceOptions.onbeforefinishcomplete.apply(_t);_t.didBeforeFinish=false;_t.didJustBeforeFinish=false;if(_t.instanceCount){_t.instanceCount--;if(!_t.instanceCount){_t.instanceCount=0;_t.instanceOptions={};}}};};if(this.flashVersion==9){this.defaultOptions=this._mergeObjects(this.defaultOptions,this.flash9Options);}
if(window.addEventListener){window.addEventListener('focus',_s.handleFocus,false);window.addEventListener('load',_s.beginDelayedInit,false);window.addEventListener('unload',_s.destruct,false);if(_s._tryInitOnFocus)window.addEventListener('mousemove',_s.handleFocus,false);}else if(window.attachEvent){window.attachEvent('onfocus',_s.handleFocus);window.attachEvent('onload',_s.beginDelayedInit);window.attachEvent('unload',_s.destruct);}else{soundManager.onerror();soundManager.disable();};if(document.addEventListener)document.addEventListener('DOMContentLoaded',_s.domContentLoaded,false);var SM2_COPYRIGHT=['SoundManager 2: Javascript Sound for the Web','http://schillmania.com/projects/soundmanager2/','Copyright (c) 2008, Scott Schiller. All rights reserved.','Code provided under the BSD License: http://schillmania.com/projects/soundmanager2/license.txt',];};var soundManager=new SoundManager();