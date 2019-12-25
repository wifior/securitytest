Spring Security权限控制的一个核心关键就是过滤器链，过滤器链由FilterComparator维护了一个顺序的注册表filterToOrder.

#### 功能：

Authentication: 认证，用户登录

Authorization:授权，判断用户是否拥有权限，可以访问哪些资源

### 1.Filter

- WebAsyncManagerIntegrationFilter : 
- SecurityContextPersistenceFileter :

权限之前一直用Apache Shiro,最近项目上用到Spring Security，所以就把集成步骤写下来。

首先我们创建一个mavan项目,

#### 1.集成所需的jar包
```xml
<properties>
    <spring.version>5.2.2.RELEASE</spring.version>
    <spring.security.version>5.2.1.RELEASE</spring.security.version>
    <jstl.version>1.2</jstl.version>
    <servlet.version>2.5</servlet.version>
</properties>

 <dependencies>
    <!-- spring -->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-core</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-web</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <!-- spring mvc -->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <!-- spring security -->
    <dependency>
      <groupId>org.springframework.security</groupId>
      <artifactId>spring-security-web</artifactId>
      <version>${spring.security.version}</version>
    </dependency>
    <dependency>
      <groupId>org.springframework.security</groupId>
      <artifactId>spring-security-config</artifactId>
      <version>${spring.security.version}</version>
    </dependency>

    <dependency>
      <groupId>jstl</groupId>
      <artifactId>jstl</artifactId>
      <version>${jstl.version}</version>
    </dependency>
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>servlet-api</artifactId>
      <version>${servlet.version}</version>
      <scope>provided</scope>
      <!--对于scope=provided的情况，则可以认为这个provided是目标容器已经provide这个artifact。-->
    </dependency>
  </dependencies>

<build>
    <finalName>ssmvc</finalName>
    <!-- <pluginManagement>--> <!--加上这句在Maven Projects中的Plugins中不会显示tomcat7插件，注释后也可在"Edit Configurations..."配置，Command line:tomcat7:run -f pom.xml -->
      <plugins>
         <plugin>
           <groupId>org.apache.maven.plugins</groupId>
           <artifactId>maven-compiler-plugin</artifactId>
           <version>3.6.0</version>
           <configuration>
             <source>1.8</source>
             <target>1.8</target>
           </configuration>
         </plugin>
        <plugin>
          <groupId>org.apache.tomcat.maven</groupId>
          <artifactId>tomcat7-maven-plugin</artifactId>
          <version>2.2</version>
          <configuration>
            <port>8000</port>
            <path>/ssmvc</path>
            <server>tomcat7</server>
          </configuration>
        </plugin>
      </plugins>
    <!--</pluginManagement>-->
  </build>
```



#### 2.web.xml配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">

  <!--spring security filter chain-->
  <filter>
    <filter-name>springSecurityFilterChain</filter-name>
    <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
  </filter>
  <filter-mapping>
    <filter-name>springSecurityFilterChain</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>

  <!--start spring -->
  <listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
  </listener>
  <context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>
      classpath:applicationContext.xml
      classpath:spring-security.xml
    </param-value>
  </context-param>

  <!-- start springMVC -->
  <!-- view https://docs.spring.io/spring-security/site/docs/5.2.1.RELEASE/reference/htmlsingle/#servlet-hello-xml-webxml-->
  <servlet>
    <servlet-name>DispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:spring-mvc.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
    <servlet-name>DispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
  </servlet-mapping>
</web-app>

```

applicationContext.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
                http://www.springframework.org/schema/context
      http://www.springframework.org/schema/context/spring-context.xsd
      http://www.springframework.org/schema/aop
                http://www.springframework.org/schema/aop/spring-aop.xsd">
</beans>
```



spring-mvc.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
                http://www.springframework.org/schema/context
      http://www.springframework.org/schema/context/spring-context.xsd
      http://www.springframework.org/schema/mvc
                http://www.springframework.org/schema/aop/spring-mvc.xsd">
     <!--package scan -->
    <context:component-scan base-package="com.test"/>

    <mvc:annotation-driven/>

    <mvc:resources mapping="/static/**" location="/static/"/>

    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/views/"/>
        <property name="suffix" value=".jsp"/>
    </bean>
</beans>
```



spring-security.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:security="http://www.springframework.org/schema/security"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
          http://www.springframework.org/schema/beans/spring-beans.xsd
          http://www.springframework.org/schema/security
          http://www.springframework.org/schema/security/spring-security.xsd">

     <security:http>
        <!-- pattern: 要拦截的资源-->
        <security:intercept-url pattern="/**" access="isFullyAuthenticated()"/>
        <security:http-basic/>
    </security:http>

    <security:authentication-manager>
        <security:authentication-provider>
            <security:user-service>
                <security:user name="admin" password="{noop}123456" authorities="ROLE_USER"/>
            </security:user-service>
        </security:authentication-provider>
    </security:authentication-manager>
</beans>
```

#### 3.运行

此时我们运行之后，会弹出用户名密码，我们输入上方的用户名密码即可登录。这样我们第一步就算成功了。







#### 错误：

> 严重: Exception starting filter springSecurityFilterChain
> org.springframework.beans.factory.NoSuchBeanDefinitionException: No bean named 'springSecurityFilterChain' available

```xml
这个错误是我们没有在spring-sercurity中添加
 <security:http>
        <security:http-basic/>
    </security:http>

    <security:authentication-manager>

    </security:authentication-manager>
```

> ```
> HTTP Status 500 - Filter execution threw an exception
> 
> exception
> 
> javax.servlet.ServletException: Filter execution threw an exception
> root cause
> 
> java.lang.NoSuchMethodError: javax.servlet.http.HttpServletRequest.changeSessionId()Ljava/lang/String;
> 	org.springframework.security.web.authentication.session.ChangeSessionIdAuthenticationStrategy.applySessionFixation(ChangeSessionIdAuthenticationStrategy.java:40)
> 	org.springframework.security.web.authentication.session.AbstractSessionFixationProtectionStrategy.onAuthentication(AbstractSessionFixationProtectionStrategy.java:87)
> 	org.springframework.security.web.authentication.session.ChangeSessionIdAuthenticationStrategy.onAuthentication(ChangeSessionIdAuthenticationStrategy.java:28)
> 	org.springframework.security.web.authentication.session.CompositeSessionAuthenticationStrategy.onAuthentication(CompositeSessionAuthenticationStrategy.java:89)
> 	org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter.doFilter(AbstractAuthenticationProcessingFilter.java:218)
> 	org.springframework.security.web.FilterChainProxy$VirtualFilterChain.doFilter(FilterChainProxy.java:334)
> 	org.springframework.security.web.header.HeaderWriterFilter.doHeadersAfter(HeaderWriterFilter.java:92)
> 	org.springframework.security.web.header.HeaderWriterFilter.doFilterInternal(HeaderWriterFilter.java:77)
> 	org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:119)
> ```

```xml
<security:http>
        <security:session-management session-fixation-protection="none" />
    </security:http>
```

说明：

#### mvc:annotation-driven的作用

```tex
这个配置默认会帮我们注册默认处理请求，参数和返回值的类，其中最主要的两个类：DefaultAnnotationHandlerMapping 和 AnnotationMethodHandlerAdapter ，分别为HandlerMapping的实现类和HandlerAdapter的实现类，但从3.1.x版本开始对应实现类改为了RequestMappingHandlerMapping和RequestMappingHandlerAdapter。
 
HandlerMapping的实现类的作用
实现类RequestMappingHandlerMapping，它会处理@RequestMapping 注解，并将其注册到请求映射表中。
 
HandlerAdapter的实现类的作用
实现类RequestMappingHandlerAdapter，则是处理请求的适配器，确定调用哪个类的哪个方法，并且构造方法参数，返回值。
 
当配置了mvc:annotation-driven/后，Spring就知道了我们启用注解驱动。然后Spring通过context:component-scan/标签的配置，会自动为我们将扫描到的@Component，@Controller，@Service，@Repository等注解标记的组件注册到工厂中，来处理我们的请求。
```





---

### springsecurity 执行原理

spring security 是通过springsecurityfilterChain过滤器链

配置为自定义的登陆页面

```xml
  <security:http>
        <!-- pattern: 要拦截的资源-->

        <security:intercept-url pattern="/loginTest" access="permitAll()"/>
        <security:intercept-url pattern="/static/**" access="isAnonymous()"/>
        <security:intercept-url pattern="/**" access="isFullyAuthenticated()"/>
        <!--<security:http-basic/>-->
        <security:form-login login-page="/loginTest" login-processing-url="/loginForm" default-target-url="/index"/>

        <security:csrf disabled="true"/>
    </security:http>
```

---

