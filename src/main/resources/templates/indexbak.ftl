<!DOCTYPE html>
<html>
<head>
    <title>Hello WebSocket</title>
    <script src="static/js/sockjs-0.3.4.js"></script>
    <script src="static/js/stomp.js"></script>
    <script type="text/javascript">
        var stompClient = null;

        function setConnected(connected) {
            document.getElementById('connect').disabled = connected;
            document.getElementById('disconnect').disabled = !connected;
            document.getElementById('conversationDiv').style.visibility = connected ? 'visible' : 'hidden';
            document.getElementById('response').innerHTML = '';
        }

        function connect() {
            var socket = new SockJS('/hello');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function(frame) {
                setConnected(true);
                console.log('Connected: ' + frame);
                stompClient.subscribe('/topic/greetings', function(greeting){
                    showGreeting(JSON.parse(greeting.body).content);
                });
            });
        }

        function disconnect() {
            if (stompClient != null) {
                stompClient.disconnect();
            }
            setConnected(false);
            console.log("Disconnected");
        }

        function sendName() {
            var name = document.getElementById('name').value;
            stompClient.send("/app/hello", {}, JSON.stringify({ 'name': name }));
        }

        function showGreeting(message) {
            var response = document.getElementById('response');
            var p = document.createElement('p');
            p.style.wordWrap = 'break-word';
            p.appendChild(document.createTextNode(message));
            response.appendChild(p);
        }
    </script>
</head>

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">预警平台</a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav">
                <li><a href="http://u1961b1648.51mypc.cn:24850" target="view_window">布防管理</a></li>
                <li><a href="/anytec/historyManager.html" target="view_window">查询历史</a></li>
            </ul>
        <#--<ul class="nav navbar-nav navbar-right">-->
        <#--<li><a href="#"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>-->
        <#--</ul>-->
        </div>
    </div>
</nav>

<div class="jumbotron">
    <div class="container text-center">
        <h1>预警平台</h1>
    </div>
</div>

<#--<img height='120px' width='200px' class="thumbnail" src="static/img/shly.jpeg" data-toggle="modal" data-target="#myModal" />-->
<#--<h2>创建模态框（Modal）</h2>-->
<#--<!-- 按钮触发模态框 &ndash;&gt;-->
<#--&lt;#&ndash;<button class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">开始演示模态框</button>&ndash;&gt;-->
<#--<!-- 模态框（Modal） &ndash;&gt;-->
<#--<div class="modal fade" id="myModal" tabindex="-1">-->
<#--<div class="modal-dialog modal-lg">-->
<#--<div class="modal-content">-->
<#--&lt;#&ndash;<div class="modal-header">&ndash;&gt;-->
<#--&lt;#&ndash;<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>&ndash;&gt;-->
<#--&lt;#&ndash;<h4 class="modal-title">显示大图</h4>&ndash;&gt;-->
<#--&lt;#&ndash;</div>&ndash;&gt;-->
<#--<img src="static/img/shly.jpeg" class="col-xs-9 thumbnail " data-toggle="modal"/>-->
<#--</div><!-- /.modal-content &ndash;&gt;-->
<#--</div><!-- /.modal &ndash;&gt;-->
<#--</div>-->
<div id="outerdiv"
     style="position:fixed;top:0;left:0;background:rgba(0,0,0,0.7);z-index:2;width:100%;height:100%;display:none;">
    <div id="innerdiv" style="position:absolute;">
        <img id="bigimg" style="border:5px solid #fff;" src=""/>
    </div>
</div>
<div class="container-fluid bg-3 text-center">
    <div class="row" id="showIdentifyResults">
        <div class="col-xs-4 col-sm-4">
        <#--<div class="col-xs-4">-->
                <#--<img class="col-xs-12 thumbnail" src="/static/img/system_demo.png">-->
                <#--<p>切出人脸图</p>-->
            <#--</div>-->
            <#--<div class="col-xs-4">-->
                <#--<img class=" col-xs-12 thumbnail" src="/static/img/system_demo.png">-->
                <#--<p>库中图</p>-->
            <#--</div>-->
            <#--<div class="col-xs-4">-->
                <#--<img class="col-xs-12 thumbnail" src="/static/img/system_demo.png">-->
                <#--<p>原图</p>-->
            <#--</div>-->
            <#--<div class="col-xs-12">-->
                <#--<p>相似度</p>-->
                <#--<p>摄像头</p>-->
                <#--<p>姓名</p>-->
                <#--<p>时间</p>-->
            <#--</div>-->
        </div>
    </div>
</div>

<body onload="disconnect()">
<noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websocket relies on Javascript being enabled. Please enable
    Javascript and reload this page!</h2></noscript>
<div>
    <div>
        <button id="connect" onclick="connect();">Connect</button>
        <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>
    </div>
    <div id="conversationDiv">
        <label>What is your name?</label><input type="text" id="name" />
        <button id="sendName" onclick="sendName();">Send</button>
        <p id="response"></p>
    </div>
</div>
</body>
</html>
