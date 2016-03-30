package com.carina_saas_example.util;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Properties;

import org.apache.commons.lang3.RandomStringUtils;
import org.jclouds.ContextBuilder;
import org.jclouds.docker.DockerApi;
import org.jclouds.docker.domain.ContainerSummary;
import org.jclouds.logging.slf4j.config.SLF4JLoggingModule;

import com.google.common.base.Predicate;
import com.google.common.collect.ImmutableSet;
import com.google.common.io.Files;
import com.google.inject.Module;

public class Utils {
   public static DockerApi getDockerApiFromCarinaDirectory(String path) throws IOException {

      // docker.ps1 contains the endpoint
      String endpoint = "https://" +
            Files.readFirstLine(new File(joinPath(path, "docker.ps1")),
                  Charset.forName("UTF-8")).split("=")[1].replace("\"", "").substring(6);

      // enable logging
      Iterable<Module> modules = ImmutableSet.<Module> of(new SLF4JLoggingModule());
      Properties overrides = new Properties();

      // disable certificate checking for Carina
      overrides.setProperty("jclouds.trust-all-certs", "true");

      return ContextBuilder.newBuilder("docker")
            // Use the unencrypted credentials
            .credentials(joinPath(path, "cert.pem"), joinPath(path, "key.pem"))
            .overrides(overrides)
            .endpoint(endpoint)
            .modules(modules)
            .buildApi(DockerApi.class);
   }

   // Concatenate two different paths
   public static String joinPath(String path1, String path2) {
      return new File(path1, path2).toString();
   }

   public static <T> Collection<T> filter(Collection<T> target, Predicate<T> predicate) {
      Collection<T> result = new ArrayList<T>();
      for (T element: target) {
         if (predicate.apply(element)) {
            result.add(element);
         }
      }
      return result;
   }

   public static Predicate<ContainerSummary> isMumble = new Predicate<ContainerSummary>() {
      public boolean apply(ContainerSummary container) {
         if (container.names().get(0) != null && container.names().get(0).contains("mumble")) {
            return true;
         } else {
            return false;
         }
      }
   };

   public static String getSecurePassword() {
      String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      return RandomStringUtils.random( 10, 0, 0, false, false, characters.toCharArray(), new SecureRandom() );
   }
}
