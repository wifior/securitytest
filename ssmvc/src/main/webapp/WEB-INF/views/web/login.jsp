<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    %>
    <base href="<%=basePath%>">
    <link href="/static/css/style.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="wrapper">
    <div class="header">Login to <span>ssmvc</span></div>
    <form action="${pageContext.request.contextPath}/loginForm" method="post">
        <ul>
            <li>
                <div class="text"><span class="name"></span><input type="text" name="username" placeholder="请输入用户名"></div>
            </li>
            <li>
                <div class="password"><span class="pwd"></span><input type="password" name = "password" placeholder="请输入密码"></div>
            </li>
            <li class="remember"><input type="checkbox">记住我</li>
            <li><a href="">忘记我</a></li>
            <li><input type="submit" value="登陆"></li>
        </ul>
    </form>
</div>
</body>
</html>
