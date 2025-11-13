package com.exam.Util;



import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;

import net.sourceforge.tess4j.ITesseract;
import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;
 
@Component
public class OcrUtil {
 
 
	
	private static final String TESSDATA_PATH="C:\\Users\\Anil\\Desktop\\Aadhar Verification\\tessdata";
    public static String extractAadharNumber(String imagePath) throws TesseractException {
        String rawText = extractText(imagePath);
        Pattern pattern = Pattern.compile("\\d{4}\\s?\\d{4}\\s?\\d{4}");
        Matcher matcher = pattern.matcher(rawText.replaceAll("\\s+", ""));
        return matcher.find() ? matcher.group().replaceAll("\\s+", "") : null;
    }
 
    public static String extractPanNumber(String imagePath) throws TesseractException {
        String rawText = extractText(imagePath);
        Pattern pattern = Pattern.compile("[A-Z]{5}[0-9]{4}[A-Z]");
        Matcher matcher = pattern.matcher(rawText.replaceAll("\\s+", "").toUpperCase());
        return matcher.find() ? matcher.group() : null;
    }
 
    public static String extractGstNumber(String imagePath) throws TesseractException {
        String rawText = extractText(imagePath);
        Pattern pattern = Pattern.compile("\\d{2}[A-Z]{5}\\d{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}");
        Matcher matcher = pattern.matcher(rawText.replaceAll("\\s+", "").toUpperCase());
        return matcher.find() ? matcher.group() : null;
    }
 
    private static String extractText(String imagePath) throws TesseractException {
        ITesseract tesseract = new Tesseract();
        tesseract.setDatapath(TESSDATA_PATH);
        tesseract.setLanguage("eng");
        return tesseract.doOCR(new File(imagePath));
    }
}