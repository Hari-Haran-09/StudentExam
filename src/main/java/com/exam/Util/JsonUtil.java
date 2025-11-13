//package com.exam.Util;
//
//import com.fasterxml.jackson.core.JsonProcessingException;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import java.util.List;
//
//public class JsonUtil {
//    private static final ObjectMapper objectMapper = new ObjectMapper();
//    
//    public static String toJson(List<String> list) {
//        try {
//            return objectMapper.writeValueAsString(list);
//        } catch (JsonProcessingException e) {
//            return "[]";
//        }
//    }
//    
//    public static List<String> fromJson(String json) {
//        try {
//            return objectMapper.readValue(json, 
//                objectMapper.getTypeFactory().constructCollectionType(List.class, String.class));
//        } catch (Exception e) {
//            return List.of();
//        }
//    }
//}


package com.exam.Util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;

public class JsonUtil {
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    public static String toJson(List<String> list) {
        try {
            return objectMapper.writeValueAsString(list);
        } catch (JsonProcessingException e) {
            return "[]";
        }
    }
    
    public static List<String> fromJson(String json) {
        try {
            return objectMapper.readValue(json, 
                objectMapper.getTypeFactory().constructCollectionType(List.class, String.class));
        } catch (Exception e) {
            return List.of();
        }
    }
    
    // Additional utility method for arrays
    public static String arrayToJson(String[] array) {
        if (array == null || array.length == 0) {
            return "[]";
        }
        try {
            return objectMapper.writeValueAsString(array);
        } catch (JsonProcessingException e) {
            return "[]";
        }
    }
}