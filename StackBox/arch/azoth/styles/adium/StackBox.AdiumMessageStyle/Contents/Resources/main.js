
	var currentVersion = '1.3.4';
	function slideHeader ( ) {
		var header    = document.getElementById ( "header" ); if ( !header ) return ( false );
		var collapse  = header.offsetTop >= 0;

		document.getElementById ( "header" ).style.top = collapse ? ( 20 - header.offsetHeight ) + "px" : 0;
		document.getElementById ( "header" ).className = collapse ? "collapsed" : "";

		Chat.style.marginTop = 20 - header.offsetTop + "px";
		if ( document.getElementById ( "StackBoxUpdated" ).open )
			setTimeout ( 'document.getElementById ( "StackBoxUpdated" ).style.top = Chat.offsetTop + "px";', 1 );
		}

	function showPreferences ( show ) { var show = show || 0; show = show ? 1 : 0;
		document.getElementById ( "PreferenceFocus" ).style.display = "block";
		if ( !show ) setTimeout ( 'document.getElementById ( "PreferenceFocus" ).style.display = "none";', 200 );
		setTimeout ( 'document.getElementById ( "Preferences" ).style.opacity = ' + ( show ? 1 : 0 ), 1 );
		document.getElementById ( "showPreferences" ).className = show ? "active" : "";

		if ( document.getElementById ( "header" ) && !( Chat.className && /hasheader/i.test ( Chat.className ) ) ) {
			Chat.className+= " hasHeader";
			Chat.style.marginTop = document.getElementById ( "header" ).offsetHeight + "px";
			}
		
		Chat.className = Chat.className.replace ( /keepstamps/mig, " " );
		if ( getCookie ( "stamps" ) ) {
			Chat.className+= " KeepStamps";
			document.getElementById ( "KeepStamps" ).checked = true;
			}
		
		if ( !( document.getElementById ( "ircVerify" ) && document.getElementById ( "ircVerify" ).className.match ( "irc" ) ) )
			Chat.className = Chat.className.replace ( /irc/mig, " " );
		if ( getCookie ( "irc4ever" ) ) {
			Chat.className+= " irc";
			if ( getCookie ( "irc4ever" ) == 1 ) document.getElementById ( "AlwaysIRC" ).checked = true;
			}

		document.getElementById ( "KeepStamps" ).checked =  getCookie ( "stamps"   ) == 1;
		document.getElementById ( "AlwaysIRC"  ).checked =  getCookie ( "irc4ever" ) == 1;
		document.getElementById ( "NoUpdates"  ).checked = !getCookie ( "updates"  );
		}

	function savePreferences ( ) {
		var keepStamps = ( document.getElementById ( "KeepStamps" ).checked && document.getElementById ( "KeepStamps" ).checked != "false" ) ? 1 : 0; setCookie ( "stamps",   keepStamps, 356 );
		var alwaysIRC  = ( document.getElementById ( "AlwaysIRC"  ).checked && document.getElementById ( "AlwaysIRC"  ).checked != "false" ) ? 1 : 0; setCookie ( "irc4ever", alwaysIRC,  356 );
		var noUpdates  = ( document.getElementById ( "NoUpdates"  ).checked && document.getElementById ( "NoUpdates"  ).checked != "false" ) ? 0 : 1; setCookie ( "updates",  noUpdates,  356 );
		showPreferences ( 1 );
		showPreferences ( 0 );
		}

	function stopUpdating ( ) {
		document.getElementById ( "StackBoxUpdated" ).style.display = "none"; setCookie ( "updates",  noUpdates, 356 );
		}

	function loadIcon ( icon, fail ) { var fail = fail || 0;
		if ( !icon.src ) { return ( false ); }
		if ( document.getElementById ( "StackBoxUpdated" ).open )
			setTimeout ( 'document.getElementById ( "StackBoxUpdated" ).style.top = Chat.offsetTop + "px";', 1 );

		if ( !icon || !icon.src || ( !fail && icon.src.match ( "Blank.png" ) ) ) return ( false );
		if ( !fail ) icon.setAttribute ( "style", icon.getAttribute ( "style" ) + "; background-image: url('" + icon.src + "') !important" );
		if ( !fail && icon.parentNode.className.match ( "incoming" ) ) document.getElementById ( "headerIcon" ).setAttribute ( "style", "background-image: url('" + icon.src + "') !important" );
		icon.setAttribute ( "src", "Blank.png" );
		}

	function fixStyle ( ) {
		var messages = document.getElementsByClassName ( "messagemessage" );
		var obj, val; for ( obj = 0; messages[ obj ] && ( val = messages[ obj ] ); obj++ )
			if ( !val.verified ) {
				if ( /consecutive.*(mention|focus).*messagemessage/i.test ( val.className ) && ( styles = val.className.match ( /mention|focus/ig ) ) )
					val.parentNode.parentNode.className+= ' ' + styles.join( ' ' );

				val.innerHTML = val.innerHTML.replace ( /\<br\>/mig, '<br /><span style="position: absolute; z-index: -10">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>' );
				val.verified = true;
				}

		var emoticons = document.getElementsByClassName ( "emoticon" );
		var obj, val; for ( obj = 0; emoticons[ obj ] && ( val = emoticons[ obj ] ); obj++ )
			if ( !val.verified ) {
				val.alt = val.alt || val.getAttribute ( "alt" ) || val.attributes[ "alt" ] ? val.attributes[ "alt" ].value : "[emoticon]";
				var emote = document.createElement ( 'span' );
					emote.className = "hidden";
					emote.innerHTML = val.alt;
				val.parentNode.insertBefore ( emote, val );
				val.verified = true;
				}
		}

	function setCookie ( cookie, value, lifetime ) { var cookie = cookie || 0, value = value || "", lifetime = lifetime || 0;
		var date = new Date ( new Date ( ).getTime ( ) + ( lifetime * 86400000 ) ); // convert days cookie remains in memory to millisec
		if ( cookie ) document.cookie = cookie + "=" + value + "; expires=" + date.toGMTString ( );
		}

	function getCookie ( cookie ) { var cookie = cookie || 0;
		if ( document.cookie && ( document.cookie.toLowerCase ( ) ).match ( cookie.toLowerCase ( ) ) ) {
			var allCookies = document.cookie.split ( "; " ), foundCookies = [ ];
			var a = 0; while ( allCookies[ a ] ) {
				var b = allCookies[ a++ ].split ( "=" );
				if ( b[ 0 ].toLowerCase ( ) == cookie.toLowerCase ( ) )
					return ( b[ 1 ] == parseFloat ( b[ 1 ] ) ? parseFloat ( b[ 1 ] ) : b[ 1 ] );
				}
			}
		return ( null );
		}

	function initializeStackBox ( ) {
//		console.log ( "load" ); // debug
//		console.log ( document.cookie ); // debug
		window.Chat = document.getElementById ( "Chat" );
		if ( document.getElementById ( "VersionNumber" ) && currentVersion )
			document.getElementById ( "VersionNumber" ).innerHTML = "StackBox Version: " + currentVersion;

		showPreferences ( );

		if ( getCookie ( "updates" ) != 0 && getCookie ( "checked" ) != 1 ) {
			setCookie ( "checked", 1, .5 );
			var AJAX = new XMLHttpRequest ( );
			if ( AJAX ) {
				AJAX.open ( "GET", "http://www.adiumxtras.com/index.php?a=xtras&xtra_id=8201", 1 );
				AJAX.onreadystatechange = function ( ) {
					if ( this.status == 200 && /current version/i.test ( this.responseText ) ) {
						var  version = ( this.responseText.toLowerCase ( ) ).match ( /current version[^\d\.]*([\d\.]+)/i );
						if ( version && version[ 1 ] && version[ 1 ] != currentVersion ) {
							document.getElementById ( "StackBoxVersion" ).innerHTML = version[ 1 ];
							verifyUpdate ( );
							this.abort ( );
							}
						}
					}
		
				AJAX.send ( "" );
				}
			}
		else
			document.getElementById ( "NoUpdates" ).checked = !getCookie ( "updates" );
		}

	function verifyUpdate ( ) {
		var AJAX = new XMLHttpRequest ( );
		if ( AJAX ) {
			AJAX.open ( "GET", "http://www.adiumxtras.com/download/8201", 1 );
			AJAX.downloadable = false;
			AJAX.onreadystatechange = function ( ) {
				if ( this.status == 200 ) {
					this.downloadable = !/text/i.test ( this.getResponseHeader ( "Content-Type" ) );
					this.abort ( );
					}

				if ( this.downloadable ) { this.downloadable = false;
					document.getElementById( "StackBoxUpdated" ).open = 1;
					console.log ( "New version available!" );
					loadIcon ( );
					}
				}
	
			AJAX.send ( "" );
			}
		}

	setTimeout ( 'initializeStackBox ( );', 250 );
