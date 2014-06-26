
    
    <div id="content-jgs" class="fl-jgs-screenNavigator-scroll-container" >

 	 <div class="box fl-panel" id="login-jgs">
			<form:form method="post" id="fm1" cssClass="fm-v clearfix" commandName="${commandName}" htmlEscape="true">
                  <form:errors path="*" id="msg" cssClass="errors" element="div" />
                <!-- <spring:message code="screen.welcome.welcome" /> -->
                    <div class="row fl-controls-left">
                        <label for="username" class="fl-label"><spring:message code="screen.welcome.label.netid" /></label>
						<c:if test="${not empty sessionScope.openIdLocalId}">
						<strong>${sessionScope.openIdLocalId}</strong>
						<input type="hidden" id="username" name="username" value="${sessionScope.openIdLocalId}" />
						</c:if>

						<c:if test="${empty sessionScope.openIdLocalId}">
						<spring:message code="screen.welcome.label.netid.accesskey" var="userNameAccessKey" />
						<form:input cssClass="required" cssErrorClass="error" id="username" size="25" tabindex="1" accesskey="${userNameAccessKey}" path="username" autocomplete="false" htmlEscape="true" />
						</c:if>
                    </div>
                    <div class="row fl-controls-left">
                        <label for="password" class="fl-label"><spring:message code="screen.welcome.label.password" /></label>
						<%--
						NOTE: Certain browsers will offer the option of caching passwords for a user.  There is a non-standard attribute,
						"autocomplete" that when set to "off" will tell certain browsers not to prompt to cache credentials.  For more
						information, see the following web page:
						http://www.geocities.com/technofundo/tech/web/ie_autocomplete.html
						--%>
						<spring:message code="screen.welcome.label.password.accesskey" var="passwordAccessKey" />
						<form:password cssClass="required" cssErrorClass="error" id="password" size="25" tabindex="2" path="password"  accesskey="${passwordAccessKey}" htmlEscape="true" autocomplete="off" />
                    </div>
               
                    <div class="row btn-row">
						<input type="hidden" name="lt" value="${loginTicket}" />
						<input type="hidden" name="execution" value="${flowExecutionKey}" />
						<input type="hidden" name="_eventId" value="submit" />
						<input id="remember" type="checkbox" /><label for="remember"><spring:message code="remember_password"/></label>
						<br>
                        <input class="btn-submit" name="submit" accesskey="l" value="<spring:message code="screen.welcome.button.login" />" tabindex="4" type="submit" />
                        <input class="btn-reset" name="reset" accesskey="c" value="<spring:message code="screen.welcome.button.clear" />" tabindex="5" type="reset" />
                    </div>
                    
            </form:form>
          </div>
     </div>   
<script type="text/javascript" src="/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/cas.js"></script>
<script>
                        $(".btn-submit").click(function(){
                        	if($('#remember').attr('checked')){
                        		setCookie("remember",true);
                        		setCookie("username",encrypt($("#username").val(),"000000"));
                            	setCookie("password",encrypt($("#password").val(),"000000"));
                        	}else{
                        		setCookie("remember",false);
                        		delCookie("username");
                        		delCookie("password");
                        	}
                        	return true;
                        });
                        function setCookie(name,value)
                        {
                            var Days = 30;
                            var exp = new Date();
                            exp.setTime(exp.getTime() + Days*24*60*60*1000);
                            document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
                        }
                        function getCookie(name)
                        {
                            var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
                         
                            if(arr=document.cookie.match(reg))
                         
                                return (arr[2]);
                            else
                                return null;
                        }
                        function delCookie(name){
                        	   var date = new Date();
                        	   date.setTime(date.getTime() - 10000);
                        	   document.cookie = name + "=a; expires=" + date.toGMTString();
                        	}
                        if(getCookie("username")){
                        	if(getCookie("remember")){
                        		$("#username").val(decrypt(getCookie("username"),"000000"));
                            	$("#password").val(decrypt(getCookie("password"),"000000"));
                            	$("#remember").click();
                        	}
                        	
                        }

                        
                        function encrypt(str, pwd) {
                        	  var prand = "";
                        	  for(var i=0; i<pwd.length; i++) {
                        	    prand += pwd.charCodeAt(i).toString();
                        	  }
                        	  var sPos = Math.floor(prand.length / 5);
                        	  var mult = parseInt(prand.charAt(sPos) + prand.charAt(sPos*2) + prand.charAt(sPos*3) + prand.charAt(sPos*4) + prand.charAt(sPos*5));
                        	  var incr = Math.ceil(pwd.length / 2);
                        	  var modu = Math.pow(2, 31) - 1;

                        	  var salt = Math.round(Math.random() * 1000000000) % 100000000;
                        	  prand += salt;
                        	  while(prand.length > 10) {
                        	    prand = (parseInt(prand.substring(0, 10)) + parseInt(prand.substring(10, prand.length))).toString();
                        	  }
                        	  prand = (mult * prand + incr) % modu;
                        	  var enc_chr = "";
                        	  var enc_str = "";
                        	  for(var i=0; i<str.length; i++) {
                        	    enc_chr = parseInt(str.charCodeAt(i) ^ Math.floor((prand / modu) * 255));
                        	    if(enc_chr < 16) {
                        	      enc_str += "0" + enc_chr.toString(16);
                        	    } else enc_str += enc_chr.toString(16);
                        	    prand = (mult * prand + incr) % modu;
                        	  }
                        	  salt = salt.toString(16);
                        	  while(salt.length < 8)salt = "0" + salt;
                        	  enc_str += salt;
                        	  return enc_str;
                        	}

                        	function decrypt(str, pwd) {
                        	  var prand = "";
                        	  for(var i=0; i<pwd.length; i++) {
                        	    prand += pwd.charCodeAt(i).toString();
                        	  }
                        	  var sPos = Math.floor(prand.length / 5);
                        	  var mult = parseInt(prand.charAt(sPos) + prand.charAt(sPos*2) + prand.charAt(sPos*3) + prand.charAt(sPos*4) + prand.charAt(sPos*5));
                        	  var incr = Math.round(pwd.length / 2);
                        	  var modu = Math.pow(2, 31) - 1;
                        	  var salt = parseInt(str.substring(str.length - 8, str.length), 16);
                        	  str = str.substring(0, str.length - 8);
                        	  prand += salt;
                        	  while(prand.length > 10) {
                        	    prand = (parseInt(prand.substring(0, 10)) + parseInt(prand.substring(10, prand.length))).toString();
                        	  }
                        	  prand = (mult * prand + incr) % modu;
                        	  var enc_chr = "";
                        	  var enc_str = "";
                        	  for(var i=0; i<str.length; i+=2) {
                        	    enc_chr = parseInt(parseInt(str.substring(i, i+2), 16) ^ Math.floor((prand / modu) * 255));
                        	    enc_str += String.fromCharCode(enc_chr);
                        	    prand = (mult * prand + incr) % modu;
                        	  }
                        	  return enc_str;
                        	}
</script>

