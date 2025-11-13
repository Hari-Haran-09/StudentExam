package com.exam.Util;

import java.io.*;

public class CodeExecutor {

    public static String runJava(String code) throws IOException, InterruptedException {
        File file = new File("Temp.java");
        try (FileWriter writer = new FileWriter(file)) {
            writer.write(code);
        }

        Process compile = new ProcessBuilder("javac", "Temp.java").start();
        compile.waitFor();

        Process run = new ProcessBuilder("java", "Temp").start();
        BufferedReader reader = new BufferedReader(new InputStreamReader(run.getInputStream()));
        StringBuilder output = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            output.append(line).append("\n");
        }
        return output.toString();
    }

    public static String runPython(String code) throws IOException, InterruptedException {
        File file = new File("Temp.py");
        try (FileWriter writer = new FileWriter(file)) {
            writer.write(code);
        }

        Process run = new ProcessBuilder("python", "Temp.py").start();
        BufferedReader reader = new BufferedReader(new InputStreamReader(run.getInputStream()));
        StringBuilder output = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            output.append(line).append("\n");
        }
        return output.toString();
    }

    public static String runCpp(String code) throws IOException, InterruptedException {
        File file = new File("Temp.cpp");
        try (FileWriter writer = new FileWriter(file)) {
            writer.write(code);
        }

        Process compile = new ProcessBuilder("g++", "Temp.cpp", "-o", "TempExe").start();
        compile.waitFor();

        Process run = new ProcessBuilder("./TempExe").start();
        BufferedReader reader = new BufferedReader(new InputStreamReader(run.getInputStream()));
        StringBuilder output = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            output.append(line).append("\n");
        }
        return output.toString();
    }
}
