package com.carina_saas_example.controller;

import static com.carina_saas_example.util.Utils.filter;
import static com.carina_saas_example.util.Utils.getDockerApiFromCarinaDirectory;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.UUID;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jclouds.docker.DockerApi;
import org.jclouds.docker.domain.Config;
import org.jclouds.docker.domain.Container;
import org.jclouds.docker.domain.HostConfig;

import com.carina_saas_example.util.Utils;
import com.google.common.collect.ImmutableList;

public class ContainerController extends HttpServlet {
   private static final long serialVersionUID = 1L;

   private static String INSERT = "/newcontainer.jsp";
   private static String LIST = "/listcontainer.jsp";
   private DockerApi dockerApi;

   public ContainerController() throws IOException {
      super();
      // get API
      if("true".equals( System.getProperties().getProperty("cse.embeddedTomcat") )) {
         dockerApi = getDockerApiFromCarinaDirectory("access"); // From maven
      } else {
         dockerApi = getDockerApiFromCarinaDirectory("/usr/local/access"); // From docker
      }
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String forward="";
      String action = request.getParameter("action");

      if ("delete".equalsIgnoreCase(action)){
         String containerId = request.getParameter("containerId");
         dockerApi.getContainerApi().stopContainer(containerId);
         dockerApi.getContainerApi().removeContainer(containerId);
         forward = LIST;
         request.setAttribute("containers", filter(dockerApi.getContainerApi().listContainers(), Utils.isMumble));
      } else if ("create".equalsIgnoreCase(action)){
         forward = INSERT;
         String password = Utils.getSecurePassword();
         Container container = dockerApi.getContainerApi().createContainer("mumble" + UUID.randomUUID().toString(),
               Config.builder()
                     .image("extra/mumble")
                     .hostConfig(
                           HostConfig.builder()
                                 .publishAllPorts(true)
                                 .build())
                     .env(
                           ImmutableList.of(
                                 "MAX_USERS=50",
                                 "SERVER_TEXT=Welcome to My Mumble Server",
                                 "SUPW=" + password
                           ))
                     .build());
         String id = container.id();
         dockerApi.getContainerApi().startContainer(id);

         StringBuilder address = new StringBuilder();
         for(Entry<String, List<Map<String, String>>> portList : dockerApi.getContainerApi().inspectContainer(id).networkSettings().ports().entrySet()) {
            for(Map<String, String> port: portList.getValue()) {
               address.append(portList.getKey());
               address.append(" to ");
               address.append(port.get("HostIp"));
               address.append(":");
               address.append(port.get("HostPort"));
               address.append(",");
            }
         }

         request.setAttribute("ports", dockerApi.getContainerApi().inspectContainer(id).networkSettings().ports());
         request.setAttribute("password", password);
      } else if ("list".equalsIgnoreCase(action)){
         forward = LIST;
         request.setAttribute("containers", filter(dockerApi.getContainerApi().listContainers(), Utils.isMumble));
      } else {
         forward = LIST;
         request.setAttribute("containers", filter(dockerApi.getContainerApi().listContainers(), Utils.isMumble));
      }

      RequestDispatcher view = request.getRequestDispatcher(forward);
      view.forward(request, response);
   }
}
