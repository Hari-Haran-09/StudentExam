package com.exam.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.Table;

@Entity
@Table(name = "Coding_questions")
public class CodingQuestions {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String easyQuestion;
    
    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String mediumQuestion;
    
    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String hardQuestion;
    
    private String languageName;
    
    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String easyInput;
    
    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String easyExpectedOutput;
    
    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String mediumInput;
    
    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String mediumExpectedOutput;
    
    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String hardInput;
    
    @Lob
    @Column(columnDefinition = "LONGTEXT")
    private String hardExpectedOutput;
    
    // Constructors
    public CodingQuestions() {
        super();
    }
    
    // Parameterized constructor
    public CodingQuestions(String languageName, String easyQuestion, String mediumQuestion, String hardQuestion) {
        this.languageName = languageName;
        this.easyQuestion = easyQuestion;
        this.mediumQuestion = mediumQuestion;
        this.hardQuestion = hardQuestion;
    }
    
    // Getters and Setters (keep all your existing methods)
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getEasyQuestion() {
        return easyQuestion;
    }
    
    public void setEasyQuestion(String easyQuestion) {
        this.easyQuestion = easyQuestion;
    }
    
    public String getMediumQuestion() {
        return mediumQuestion;
    }
    
    public void setMediumQuestion(String mediumQuestion) {
        this.mediumQuestion = mediumQuestion;
    }
    
    public String getHardQuestion() {
        return hardQuestion;
    }
    
    public void setHardQuestion(String hardQuestion) {
        this.hardQuestion = hardQuestion;
    }
    
    public String getLanguageName() {
        return languageName;
    }
    
    public void setLanguageName(String languageName) {
        this.languageName = languageName;
    }
    
    public String getEasyInput() {
        return easyInput;
    }
    
    public void setEasyInput(String easyInput) {
        this.easyInput = easyInput;
    }
    
    public String getEasyExpectedOutput() {
        return easyExpectedOutput;
    }
    
    public void setEasyExpectedOutput(String easyExpectedOutput) {
        this.easyExpectedOutput = easyExpectedOutput;
    }
    
    public String getMediumInput() {
        return mediumInput;
    }
    
    public void setMediumInput(String mediumInput) {
        this.mediumInput = mediumInput;
    }
    
    public String getMediumExpectedOutput() {
        return mediumExpectedOutput;
    }
    
    public void setMediumExpectedOutput(String mediumExpectedOutput) {
        this.mediumExpectedOutput = mediumExpectedOutput;
    }
    
    public String getHardInput() {
        return hardInput;
    }
    
    public void setHardInput(String hardInput) {
        this.hardInput = hardInput;
    }
    
    public String getHardExpectedOutput() {
        return hardExpectedOutput;
    }
    
    public void setHardExpectedOutput(String hardExpectedOutput) {
        this.hardExpectedOutput = hardExpectedOutput;
    }
    
    // ========== ARRAY HANDLING METHODS ==========
    
    // Universal method to format any data type for storage as [value1;value2;value3]
    private String formatArrayForStorage(String[] array) {
        if (array == null || array.length == 0) {
            return "";
        }
        
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < array.length; i++) {
            if (i > 0) {
                sb.append(";");
            }
            // Store the value as-is (numbers, booleans, strings all stored directly)
            // Remove any existing brackets to avoid double bracketing
            String value = array[i].trim();
            if (value.startsWith("[") && value.endsWith("]")) {
                value = value.substring(1, value.length() - 1);
            }
            sb.append(value);
        }
        sb.append("]");
        return sb.toString();
    }
    
    // Universal method to parse stored array
    private String[] parseStoredArray(String storedValue) {
        if (storedValue == null || storedValue.isEmpty() || 
            !storedValue.startsWith("[") || !storedValue.endsWith("]")) {
            return new String[0];
        }
        
        String content = storedValue.substring(1, storedValue.length() - 1);
        if (content.isEmpty()) {
            return new String[0];
        }
        
        return content.split(";");
    }
    
    // ========== EASY LEVEL ARRAY METHODS ==========
    
    public String[] getEasyInputArray() {
        return parseStoredArray(this.easyInput);
    }
    
    public void setEasyInputArray(String[] easyInputArray) {
        this.easyInput = formatArrayForStorage(easyInputArray);
    }
    
    public String[] getEasyExpectedOutputArray() {
        return parseStoredArray(this.easyExpectedOutput);
    }
    
    public void setEasyExpectedOutputArray(String[] easyExpectedOutputArray) {
        this.easyExpectedOutput = formatArrayForStorage(easyExpectedOutputArray);
    }
    
    // ========== MEDIUM LEVEL ARRAY METHODS ==========
    
    public String[] getMediumInputArray() {
        return parseStoredArray(this.mediumInput);
    }
    
    public void setMediumInputArray(String[] mediumInputArray) {
        this.mediumInput = formatArrayForStorage(mediumInputArray);
    }
    
    public String[] getMediumExpectedOutputArray() {
        return parseStoredArray(this.mediumExpectedOutput);
    }
    
    public void setMediumExpectedOutputArray(String[] mediumExpectedOutputArray) {
        this.mediumExpectedOutput = formatArrayForStorage(mediumExpectedOutputArray);
    }
    
    // ========== HARD LEVEL ARRAY METHODS ==========
    
    public String[] getHardInputArray() {
        return parseStoredArray(this.hardInput);
    }
    
    public void setHardInputArray(String[] hardInputArray) {
        this.hardInput = formatArrayForStorage(hardInputArray);
    }
    
    public String[] getHardExpectedOutputArray() {
        return parseStoredArray(this.hardExpectedOutput);
    }
    
    public void setHardExpectedOutputArray(String[] hardExpectedOutputArray) {
        this.hardExpectedOutput = formatArrayForStorage(hardExpectedOutputArray);
    }
    
    // ========== TYPE-SPECIFIC METHODS ==========
    
    // For integer arrays
    public void setEasyInputIntArray(Integer[] intArray) {
        if (intArray != null && intArray.length > 0) {
            String[] strArray = new String[intArray.length];
            for (int i = 0; i < intArray.length; i++) {
                strArray[i] = String.valueOf(intArray[i]);
            }
            setEasyInputArray(strArray);
        } else {
            setEasyInput("");
        }
    }
    
    public Integer[] getEasyInputIntArray() {
        String[] strArray = getEasyInputArray();
        Integer[] intArray = new Integer[strArray.length];
        for (int i = 0; i < strArray.length; i++) {
            try {
                intArray[i] = Integer.parseInt(strArray[i]);
            } catch (NumberFormatException e) {
                intArray[i] = null;
            }
        }
        return intArray;
    }
    
    // For boolean arrays
    public void setEasyInputBooleanArray(Boolean[] boolArray) {
        if (boolArray != null && boolArray.length > 0) {
            String[] strArray = new String[boolArray.length];
            for (int i = 0; i < boolArray.length; i++) {
                strArray[i] = String.valueOf(boolArray[i]);
            }
            setEasyInputArray(strArray);
        } else {
            setEasyInput("");
        }
    }
    
    public Boolean[] getEasyInputBooleanArray() {
        String[] strArray = getEasyInputArray();
        Boolean[] boolArray = new Boolean[strArray.length];
        for (int i = 0; i < strArray.length; i++) {
            boolArray[i] = Boolean.parseBoolean(strArray[i]);
        }
        return boolArray;
    }
    
    // For double arrays
    public void setEasyInputDoubleArray(Double[] doubleArray) {
        if (doubleArray != null && doubleArray.length > 0) {
            String[] strArray = new String[doubleArray.length];
            for (int i = 0; i < doubleArray.length; i++) {
                strArray[i] = String.valueOf(doubleArray[i]);
            }
            setEasyInputArray(strArray);
        } else {
            setEasyInput("");
        }
    }
    
    public Double[] getEasyInputDoubleArray() {
        String[] strArray = getEasyInputArray();
        Double[] doubleArray = new Double[strArray.length];
        for (int i = 0; i < strArray.length; i++) {
            try {
                doubleArray[i] = Double.parseDouble(strArray[i]);
            } catch (NumberFormatException e) {
                doubleArray[i] = null;
            }
        }
        return doubleArray;
    }
    
    // Similar methods can be added for other difficulty levels and output fields
    
    // ========== UTILITY METHODS ==========
    
    public int getEasyTestCaseCount() {
        return getEasyInputArray().length;
    }
    
    public int getMediumTestCaseCount() {
        return getMediumInputArray().length;
    }
    
    public int getHardTestCaseCount() {
        return getHardInputArray().length;
    }
    
    public int getTotalTestCaseCount() {
        return getEasyTestCaseCount() + getMediumTestCaseCount() + getHardTestCaseCount();
    }
    
    @Override
    public String toString() {
        return "CodingQuestions{" +
                "id=" + id +
                ", languageName='" + languageName + '\'' +
                ", easyQuestion='" + easyQuestion + '\'' +
                ", mediumQuestion='" + mediumQuestion + '\'' +
                ", hardQuestion='" + hardQuestion + '\'' +
                ", easyInput='" + easyInput + '\'' +
                ", easyExpectedOutput='" + easyExpectedOutput + '\'' +
                ", mediumInput='" + mediumInput + '\'' +
                ", mediumExpectedOutput='" + mediumExpectedOutput + '\'' +
                ", hardInput='" + hardInput + '\'' +
                ", hardExpectedOutput='" + hardExpectedOutput + '\'' +
                '}';
    }
}