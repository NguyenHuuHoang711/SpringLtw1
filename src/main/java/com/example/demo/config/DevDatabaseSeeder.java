package com.example.demo.config;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.Statement;

/**
 * Dev-only database seeder. Executes seed SQL using native JDBC to support T-SQL syntax.
 * Tries project root first, then falls back to classpath.
 * Runs only when profile=dev to prevent accidental execution in production.
 */
@Component
@Profile("dev")
@RequiredArgsConstructor
public class DevDatabaseSeeder implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(DevDatabaseSeeder.class);

    private final DataSource dataSource;

    @Override
    public void run(ApplicationArguments args) {
        Resource resource = findSeedResource();
        if (resource == null) {
            log.warn("No seed SQL found. Skipping seeding.");
            return;
        }

        try {
            executeSeedSQL(resource);
            log.info("Dev seed SQL executed successfully.");
        } catch (Exception ex) {
            log.error("Failed to execute seed SQL: {}", ex.getMessage());
            log.debug("Detailed error:", ex);
            // Don't rethrow - allow app to continue even if seeding fails
            // (tables might already have data, or we're in a test environment)
        }
    }

    private Resource findSeedResource() {
        // Try project root first
        String projectPath = System.getProperty("user.dir");
        File projectSeed = new File(projectPath + "/document/database/seed_demo.sql");
        if (projectSeed.exists()) {
            log.info("Using seed SQL from: {}", projectSeed.getAbsolutePath());
            return new FileSystemResource(projectSeed);
        }

        // Fallback to classpath
        Resource cp = new ClassPathResource("db/seed_demo_simple.sql");
        if (cp.exists()) {
            log.info("Using seed SQL from classpath: db/seed_demo_simple.sql");
            return cp;
        }

        return null;
    }

    private void executeSeedSQL(Resource resource) throws Exception {
        String content = readResourceAsString(resource);
        if (content == null || content.trim().isEmpty()) {
            log.warn("Seed SQL file is empty.");
            return;
        }

        // Split by GO on its own line(s) - MSSQL batch separator
        String[] batches = content.split("(?im)^\\s*GO\\s*$");
        log.info("Seed SQL split into {} batches", batches.length);

        try (Connection conn = dataSource.getConnection()) {
            int successCount = 0;
            for (int i = 0; i < batches.length; i++) {
                String trimmed = batches[i].trim();
                if (trimmed.isEmpty()) {
                    log.debug("Batch {} is empty, skipping", i);
                    continue;
                }

                try (Statement stmt = conn.createStatement()) {
                    String preview = trimmed.length() > 80 ? trimmed.substring(0, 80) + "..." : trimmed;
                    log.debug("Batch {}: Executing ({})", i, preview);
                    stmt.execute(trimmed);
                    successCount++;
                } catch (Exception ex) {
                    log.warn("Batch {} failed (continuing): {}", i, ex.getMessage());
                }
            }
            log.info("Executed {} seed SQL statements successfully.", successCount);
        }
    }

    private String readResourceAsString(Resource resource) throws Exception {
        try (InputStream is = resource.getInputStream();
             BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }
            return sb.toString();
        }
    }
}


