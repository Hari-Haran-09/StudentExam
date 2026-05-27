	package com.exam.controller;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import javax.imageio.ImageIO;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.exam.Util.OcrUtil;
import com.exam.entity.AwsMcq;
import com.exam.entity.CodingQuestions;
import com.exam.entity.Course;
import com.exam.entity.ExamScreen;
import com.exam.entity.ExamSet;
import com.exam.entity.Experience;
import com.exam.entity.JavascriptMcq;
import com.exam.entity.Language;
import com.exam.entity.ManageExam;
import com.exam.entity.Mcq;
import com.exam.entity.PassedOut;
import com.exam.entity.PhpMcq;
import com.exam.entity.PythonMcq;
import com.exam.entity.RatingEntity;
import com.exam.entity.ReactMcq;
import com.exam.entity.Role;
import com.exam.entity.Specialization;
import com.exam.entity.Student;
import com.exam.entity.TestingMcq;
import com.exam.repository.AwsRepository;
import com.exam.repository.CodingRepository;
import com.exam.repository.CourseRepository;
import com.exam.repository.ExamScreenRepository;
import com.exam.repository.ExamSetRepository;
import com.exam.repository.ExperienceRepository;
import com.exam.repository.JavascriptMcqRepository;
import com.exam.repository.LanguageRepository;
import com.exam.repository.ManageExamRepository;
import com.exam.repository.McqRepository;
import com.exam.repository.PassedOutRepository;
import com.exam.repository.PhpMcqRepository;
import com.exam.repository.PythonMcqRepository;
import com.exam.repository.RatingRepository;
import com.exam.repository.ReactMcqRepository;
import com.exam.repository.RoleRepository;
import com.exam.repository.SpecializationRepository;
import com.exam.repository.StudentRepository;
import com.exam.repository.TestingMcqRepository;
import com.exam.service.AadhrService;
import com.exam.service.StudentService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.exc.InvalidFormatException;

import jakarta.servlet.http.HttpSession;


@Controller
@RequestMapping("/student")
public class LayersController {

    @Autowired
    private StudentService studentService;
    @Autowired 
    private RoleRepository roleRepo;
    @Autowired
    private CourseRepository courseRepository;
    @Autowired 
    private SpecializationRepository specializationRepo;
    @Autowired 
    private PassedOutRepository passedOutRepo;
    @Autowired
    private ExperienceRepository experienceRepo;
    @Autowired
    private LanguageRepository languageRepo;
    @Autowired
    private StudentRepository studentRepository;
    @Autowired
    private AadhrService aadharservice;
    @Autowired
    private CodingRepository codingRepository;
    @Autowired
    private McqRepository mcqRepository;
    @Autowired
    private JavascriptMcqRepository javascriptmcqRepository;
    @Autowired
    private ReactMcqRepository reactmcqRepository;
    @Autowired
    private PythonMcqRepository pythonmcqRepository;
    @Autowired
    private TestingMcqRepository testingmcqRepository;
    @Autowired
    private PhpMcqRepository phpmcqRepository;
    @Autowired
    private ManageExamRepository manageexamRepoository;
    @Autowired
    private RatingRepository ratingrepository;
    @Autowired
    private ExamScreenRepository examscreenRepository;
    @Autowired
    private AwsRepository awsrepository;
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private OcrUtil ocrUtil;
 
    private static final String UPLOAD_DIR = "C:\\ecomData\\nssexam";
    
    private static final String BASE_URL =  "https://images.iott.co.in/nssexam";
    
    
    @GetMapping("/register")
    public String showRegisterPage() {
        return "register"; // register.jsp
    }
    @PostMapping("/register")
    public String registerUser(
            @ModelAttribute Student student,
            @RequestParam("aadharFile") MultipartFile aadharFile,
            Model model) {

        try {
            if (studentRepository.existsByEmail(student.getEmail())) {
                model.addAttribute("error", "Email already registered");
                return "register";
            }

            // Save Aadhaar file
            String fileName = saveFile(aadharFile, "aadhar", student.getEmail());
            student.setAadharFileUrl(fileName);   // store file path

            // SAVE INTO DATABASE
            studentService.registerUser(student);

            model.addAttribute("message", "Registration successful. Please login!");
            
           
            studentService.mailsender(student.getEmail(),student.getName());
            if ("Admin".equalsIgnoreCase(student.getRole())) {
                return "AdminLogin";
            } else {
                return "login";
            }
            

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error in registration");
            return "register";
        }
    }
    
    @PostMapping("/verifyAadhar")
    public ResponseEntity<?> verifyAadhar(@ModelAttribute Student student,@RequestParam("aadharFile") MultipartFile aadharFile,
                                          @RequestParam("aadharNumber") String aadharNumber
                                         ) {
        Map<String, Object> response = new HashMap<>();

        try {
        	String enteredAadhar = aadharNumber.replaceAll("\\s", "");
//            String fileName = saveFile(aadharFile, "aadhar_verify", "temp");
//            String extractedAadhar = OcrUtil.extractAadharNumber(Paths.get(UPLOAD_DIR, fileName).toString());
            
            if(aadharservice.exists(enteredAadhar)) {
            	response.put("success", false);
            	response.put("message","Aadhaar number already registered");
            	return ResponseEntity.status(HttpStatus.ACCEPTED).body(response);
            }
            String fileName = saveFile(aadharFile, "aadhar_verify", "temp");
            
            Path filePath = Paths.get(UPLOAD_DIR, fileName);          
            BufferedImage img = ImageIO.read(filePath.toFile());
            BufferedImage newImg = new BufferedImage(img.getWidth(), img.getHeight(), BufferedImage.TYPE_INT_RGB);
            newImg.createGraphics().drawImage(img, 0, 0, null);
    
          
            File convertedFile = new File(UPLOAD_DIR + "/converted_" + fileName);
            ImageIO.write(newImg, "jpg", convertedFile);
            
            String extractedAadhar = OcrUtil.extractAadharNumber(Paths.get(UPLOAD_DIR, fileName).toString());
           
            if (extractedAadhar == null) {
                response.put("success", false);
                response.put("message", "Aadhaar number could not be detected from uploaded image.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }

            if (!extractedAadhar.equals(aadharNumber.replaceAll("\\s+", ""))) {
                response.put("success", false);
                response.put("message", "Aadhaar not verified. Entered number does not match the image.");
                response.put("enteredAadhar",aadharNumber);
//              response.put("extractedAadhar", extractedAadhar);
                return ResponseEntity.ok(response);
            }
            
//
//            response.put("success", true);
//            response.put("message", "Aadhaar verified successfully.");
//            
////          response.put("extractedAadhar", extractedAadhar);
//            return ResponseEntity.ok(response);
//            
//      
//              student.setAadharNumber(aadharNumber);
//              student.setAadharFileUrl(extractedAadhar);
//            	studentRepository.save(student);
            	
            	response.put("success", true);
            	response.put("message", "Registration Sucessful");
            	return ResponseEntity.ok(response);
            

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Error during Aadhaar verification: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
       
    }
   
    private String saveFile(MultipartFile file, String prefix, String Name) throws IOException {
        String fileName = prefix + "_" + Name + "_" + System.currentTimeMillis()
                + getExtension(file.getOriginalFilename());
        Path filePath = Paths.get(UPLOAD_DIR, fileName);
        file.transferTo(filePath.toFile());
        return fileName;
    }

    private String getExtension(String filename) {
        return filename != null && filename.contains(".")
                ? filename.substring(filename.lastIndexOf("."))
                : "";
    }


    @GetMapping("/registerrr")
    @ResponseBody
    public List<Student> getAllUsers() {
    	return studentRepository.findAll();
    }
//    private static final String UPLOAD_DIR = "C:\\ecomData\\profile";
//    private static final String BASE_URL = "https://images.iott.co.in/profile";@PostMapping("/register")
//    public String registerUser(
//            @ModelAttribute Student student,
//            @RequestParam("aadharFile") MultipartFile aadharFile,
//            @RequestParam("aadharNumber") String aadharNumber,
//            Model model) {
// 
//        try {
//            if (aadharNumber != null && !aadharNumber.isEmpty() && aadharFile != null && !aadharFile.isEmpty()) {
// 
//                // ✅ 1. Save temporarily (for OCR processing)
//                Path tempDir = Files.createTempDirectory("aadhaar_temp_");
//                Path tempFilePath = tempDir.resolve(aadharFile.getOriginalFilename());
//                aadharFile.transferTo(tempFilePath.toFile());
// 
//                // ✅ 2. Extract Aadhaar number using OCR
//                String extractedAadhar = ocrUtil.extractAadharNumber(tempFilePath.toString());
// 
//                // ✅ 3. Compare entered Aadhaar vs extracted Aadhaar
//                if (extractedAadhar != null && extractedAadhar.equals(aadharNumber.replaceAll("\\s+", ""))) {
// 
//                    // ✅ 4. Aadhaar verified — now store permanently
//                    String imageUrl = uploadFile1(aadharFile, UPLOAD_DIR, BASE_URL);
// 
//                    student.setAadharNumber(aadharNumber);
//                    student.setAadharFileUrl(imageUrl); // Save final public URL to DB
// 
//                    // ✅ 5. Clean up temporary file
//                    Files.deleteIfExists(tempFilePath);
//                    Files.deleteIfExists(tempDir);
// 
//                } else {
//                    model.addAttribute("error", "Aadhaar verification failed. Number does not match the image.");
//                    return "register";
//                }
//            }
// 
//            // ✅ 6. Register the student
//            studentService.registerUser(student);
//            model.addAttribute("message", "Registration successful. Please login!");
//            return "login";
// 
//        } catch (Exception e) {
//            e.printStackTrace();
//            model.addAttribute("error", "Registration failed: " + e.getMessage());
//            return "register";
//        }
//    }
//    private String uploadFile1(MultipartFile file, String uploadDir, String baseUrl) {
//        try {
//            Path uploadPath = Paths.get(uploadDir);
//            
//            if (!Files.exists(uploadPath)) {
//                Files.createDirectories(uploadPath);
//            }
// 
//            String fileExtension = Optional.ofNullable(file.getOriginalFilename())
//                    .filter(f -> f.contains("."))
//                    .map(f -> f.substring(f.lastIndexOf(".")))
//                    .orElse("");
// 
//            String uniqueFileName = UUID.randomUUID() + fileExtension;
//            Path filePath = uploadPath.resolve(uniqueFileName);
//            Files.write(filePath, file.getBytes());
// 
//            // ✅ Return the public URL for this uploaded file
//            return baseUrl + "/" + uniqueFileName;
// 
//        } catch (IOException e) {
//            e.printStackTrace();
//            return null;
//        }
//    }
    
    
    
    
    // coding start
    
//    @PostMapping("/saveQuestions")
//    public String saveQuestion(@ModelAttribute CodingQuestions codingQuestions, Model model) {
//    	
////    	codingRepository.save(codingQuestions);
////    	model.addAttribute("Questions", "Questions Saved Successfully");
//    	try {
//            codingRepository.save(codingQuestions);
//            model.addAttribute("message", "Coding questions saved successfully for " + codingQuestions.getLanguageName());
//            model.addAttribute("messageType", "success");
//        } catch (Exception e) {
//            model.addAttribute("message", "Error saving questions: " + e.getMessage());
//            model.addAttribute("messageType", "error");
//        }
//    	return "admin5";
//    }
    @PostMapping("/saveQuestions")
    public String saveQuestion(@RequestParam String languageName,
                              @RequestParam String easyQuestion,
                              @RequestParam String mediumQuestion,
                              @RequestParam String hardQuestion,
                              @RequestParam(value = "easyInputArray", required = false) String[] easyInputArray,
                              @RequestParam(value = "easyExpectedOutputArray", required = false) String[] easyExpectedOutputArray,
                              @RequestParam(value = "mediumInputArray", required = false) String[] mediumInputArray,
                              @RequestParam(value = "mediumExpectedOutputArray", required = false) String[] mediumExpectedOutputArray,
                              @RequestParam(value = "hardInputArray", required = false) String[] hardInputArray,
                              @RequestParam(value = "hardExpectedOutputArray", required = false) String[] hardExpectedOutputArray,
                              Model model) {
        
        try {
            // Create new coding questions entity
            CodingQuestions codingQuestions = new CodingQuestions();
            codingQuestions.setLanguageName(languageName);
            codingQuestions.setEasyQuestion(easyQuestion);
            codingQuestions.setMediumQuestion(mediumQuestion);
            codingQuestions.setHardQuestion(hardQuestion);
            
            // Set test cases for EASY level
            if (easyInputArray != null && easyExpectedOutputArray != null && 
                easyInputArray.length > 0 && easyExpectedOutputArray.length > 0) {
                codingQuestions.setEasyInputArray(easyInputArray);
                codingQuestions.setEasyExpectedOutputArray(easyExpectedOutputArray);
            } else {
                codingQuestions.setEasyInput("");
                codingQuestions.setEasyExpectedOutput("");
            }
            
            // Set test cases for MEDIUM level
            if (mediumInputArray != null && mediumExpectedOutputArray != null && 
                mediumInputArray.length > 0 && mediumExpectedOutputArray.length > 0) {
                codingQuestions.setMediumInputArray(mediumInputArray);
                codingQuestions.setMediumExpectedOutputArray(mediumExpectedOutputArray);
            } else {
                codingQuestions.setMediumInput("");
                codingQuestions.setMediumExpectedOutput("");
            }
            
            // Set test cases for HARD level
            if (hardInputArray != null && hardExpectedOutputArray != null && 
                hardInputArray.length > 0 && hardExpectedOutputArray.length > 0) {
                codingQuestions.setHardInputArray(hardInputArray);
                codingQuestions.setHardExpectedOutputArray(hardExpectedOutputArray);
            } else {
                codingQuestions.setHardInput("");
                codingQuestions.setHardExpectedOutput("");
            }
            
            // Save to database
            CodingQuestions savedQuestion = codingRepository.save(codingQuestions);
            
            // Log for debugging
            System.out.println("=== SAVED CODING QUESTIONS ===");
            System.out.println("Language: " + savedQuestion.getLanguageName());
            System.out.println("Easy Input: " + savedQuestion.getEasyInput());
            System.out.println("Easy Output: " + savedQuestion.getEasyExpectedOutput());
            System.out.println("Medium Input: " + savedQuestion.getMediumInput());
            System.out.println("Medium Output: " + savedQuestion.getMediumExpectedOutput());
            System.out.println("Hard Input: " + savedQuestion.getHardInput());
            System.out.println("Hard Output: " + savedQuestion.getHardExpectedOutput());
            System.out.println("Total Test Cases: " + savedQuestion.getTotalTestCaseCount());
            System.out.println("=============================");
            
            // Add success message
            model.addAttribute("message", 
                "Coding questions saved successfully for " + languageName + 
                " with " + savedQuestion.getTotalTestCaseCount() + " total test cases!");
            model.addAttribute("messageType", "success");
            
        } catch (Exception e) {
            // Add error message
            model.addAttribute("message", "Error saving questions: " + e.getMessage());
            model.addAttribute("messageType", "error");
            e.printStackTrace();
        }
        
        return "admin5";
    }
    
    // Utility method to display stored questions (for testing)
    public void displayStoredQuestions(Long questionId) {
        CodingQuestions question = codingRepository.findById(questionId).orElse(null);
        if (question != null) {
            System.out.println("=== STORED QUESTION DATA ===");
            System.out.println("ID: " + question.getId());
            System.out.println("Language: " + question.getLanguageName());
            
            System.out.println("\n--- EASY LEVEL ---");
            System.out.println("Question: " + question.getEasyQuestion());
            System.out.println("Stored Input: " + question.getEasyInput());
            System.out.println("Stored Output: " + question.getEasyExpectedOutput());
            System.out.println("Parsed Inputs: " + Arrays.toString(question.getEasyInputArray()));
            System.out.println("Parsed Outputs: " + Arrays.toString(question.getEasyExpectedOutputArray()));
            
            System.out.println("\n--- MEDIUM LEVEL ---");
            System.out.println("Question: " + question.getMediumQuestion());
            System.out.println("Stored Input: " + question.getMediumInput());
            System.out.println("Stored Output: " + question.getMediumExpectedOutput());
            System.out.println("Parsed Inputs: " + Arrays.toString(question.getMediumInputArray()));
            System.out.println("Parsed Outputs: " + Arrays.toString(question.getMediumExpectedOutputArray()));
            
            System.out.println("\n--- HARD LEVEL ---");
            System.out.println("Question: " + question.getHardQuestion());
            System.out.println("Stored Input: " + question.getHardInput());
            System.out.println("Stored Output: " + question.getHardExpectedOutput());
            System.out.println("Parsed Inputs: " + Arrays.toString(question.getHardInputArray()));
            System.out.println("Parsed Outputs: " + Arrays.toString(question.getHardExpectedOutputArray()));
            
            System.out.println("=============================");
        }
    }
//    @GetMapping("/getQuestions")
//    @ResponseBody
//    public List<CodingQuestions> getQuestionsByLanguage(@RequestParam String languageName) {
//        return codingRepository.findByLanguageName(languageName);
//    }
    
    @Autowired
    private ExamSetRepository examSetRepository;
    
    @GetMapping("/getQuestions")
    @ResponseBody
    public List<Map<String, Object>> getQuestionsByLanguage(@RequestParam String languageName,
            @RequestParam String setName) {
    	Optional<ExamSet> optionalSet =examSetRepository.findByLanguageNameAndSetName(
    		        languageName,
    		        setName
    		    );

    		if(optionalSet.isEmpty()) {
    		    return new ArrayList<>();
    		}

    		ExamSet examSet = optionalSet.get();
    		System.out.println("CODING QUESTION ID = "
    		        + examSet.getCodingQuestionId());

    		Long codingQuestionId =examSet.getCodingQuestionId();

    		CodingQuestions codingQuestion = codingRepository .findById(codingQuestionId).orElse(null);

    		if(codingQuestion == null) {
    		    return new ArrayList<>();
    		}

    		List<CodingQuestions> questions =
    		    Arrays.asList(codingQuestion);
        
        List<Map<String, Object>> response = new ArrayList<>();
        for (CodingQuestions question : questions) {                        // error 
            Map<String, Object> questionMap = new HashMap<>();
            
            // Add basic fields
            questionMap.put("id", question.getId());
            questionMap.put("easyQuestion", question.getEasyQuestion());
            questionMap.put("mediumQuestion", question.getMediumQuestion());
            questionMap.put("hardQuestion", question.getHardQuestion());
            questionMap.put("languageName", question.getLanguageName());
            questionMap.put("easyInput", question.getEasyInput());
            questionMap.put("easyExpectedOutput", question.getEasyExpectedOutput());
            questionMap.put("mediumInput", question.getMediumInput());
            questionMap.put("mediumExpectedOutput", question.getMediumExpectedOutput());
            questionMap.put("hardInput", question.getHardInput());
            questionMap.put("hardExpectedOutput", question.getHardExpectedOutput());
            
            // Add array fields explicitly
            questionMap.put("easyInputArray", question.getEasyInputArray());
            questionMap.put("easyExpectedOutputArray", question.getEasyExpectedOutputArray());
            questionMap.put("mediumInputArray", question.getMediumInputArray());
            questionMap.put("mediumExpectedOutputArray", question.getMediumExpectedOutputArray());
            questionMap.put("hardInputArray", question.getHardInputArray());
            questionMap.put("hardExpectedOutputArray", question.getHardExpectedOutputArray());
            
            response.add(questionMap);
        }
        
        return response;
    }
    //update coding
    @PostMapping("/updateCoding/{id}")
    public ResponseEntity<String> updateCoding(
            @PathVariable("id") Long id,
            @RequestBody CodingQuestions codingData) {

        
        Optional<CodingQuestions> existingRecord = codingRepository.findById(id);
        if (existingRecord.isPresent()) {
        	CodingQuestions coding = existingRecord.get();
            coding.setLanguageName(codingData.getLanguageName());
            coding.setEasyQuestion(codingData.getEasyQuestion());
            coding.setMediumQuestion(codingData.getMediumQuestion());
            coding.setHardQuestion(codingData.getHardQuestion());
            
            
            // Update input fields
            coding.setEasyInput(codingData.getEasyInput());
            coding.setMediumInput(codingData.getMediumInput());
            coding.setHardInput(codingData.getHardInput());
            
            // Update expected output fields
            coding.setEasyExpectedOutput(codingData.getEasyExpectedOutput());
            coding.setMediumExpectedOutput(codingData.getMediumExpectedOutput());
            coding.setHardExpectedOutput(codingData.getHardExpectedOutput());

            codingRepository.save(coding);
            return ResponseEntity.ok("Updated successfully!");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Record not found for ID: " + id);
        }
    }
    
    
    // coding end
    
    
    
    
//    @PostMapping("/saveMcq")
//    public String saveMcq(@ModelAttribute Mcq mcq, Map<String, Object> map) {
//    	
//    	mcqRepository.save(mcq);
//    	
//    	map.put("mcq", "Mcq's Sucessfully Saved");
//    	
//    	return "admin6";
//    }
    
    @PostMapping("/manageExam")
    public String saveManageexam(@ModelAttribute ManageExam exam, Model model) {
    	manageexamRepoository.save(exam);
    	model.addAttribute("language", "data post for language successfully");
    	return "admin7";
    }
    
    @GetMapping("/manageExamss")
    @ResponseBody
    public List<ManageExam> getExams1() {
	return manageexamRepoository.findAll();
	}
    
    
    @GetMapping("/manageExams/byLanguage/{languageName}")
    @ResponseBody
    public List<ManageExam> getExamsByLanguage(@PathVariable String languageName) {
        return manageexamRepoository.findByLanguageName(languageName);
    }

 // Delete exam by ID
    @DeleteMapping("/manageExams/{id}")
    @ResponseBody
    public String deleteExam(@PathVariable Long id) {
        try {
            if (manageexamRepoository.existsById(id)) {
                manageexamRepoository.deleteById(id);
                return "Exam with ID " + id + " deleted successfully.";
            } else {
                return "Exam with ID " + id + " not found.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error deleting exam with ID " + id;
        }
    }

    @GetMapping("/ExamList")
    public String ExamList() {
    	return "admin8";
    }
	/*
	 * @GetMapping("/students")
	 * 
	 * @ResponseBody public long getAllStudents() { return
	 * studentRepository.count(); }
	 */
    @GetMapping("/students")
    @ResponseBody 
    public Map<String, Long> getAllStudents() {
        Map<String, Long> response = new HashMap<>();
        response.put("totalRegistered", studentRepository.count());
        return response;
    }
   
    @GetMapping("/getRoles")
    @ResponseBody
    public List<Role> getRoles() {
    	
        return roleRepo.findAll();
    }

    @GetMapping("/getCourses")
    @ResponseBody
    public List<Course> getCourses() {
        return courseRepository.findAll();
    }

    @GetMapping("/getSpecializations")
    @ResponseBody
    public List<Specialization> getSpecializations() {
        return specializationRepo.findAll();
    }

    @GetMapping("/getPassedout")
    @ResponseBody
    public List<PassedOut> getPassedOut() {
        return passedOutRepo.findAll();
    }

    @GetMapping("/getExperience")
    @ResponseBody
    public List<Experience> getExperience() {
        return experienceRepo.findAll();
    }
    
    //language api start
    @GetMapping("/getLanguage")
    @ResponseBody
    public List<Language> getLanguage(){
    	return languageRepo.findAll();
    }
    
    @GetMapping("/languageCount")
    @ResponseBody
    public Map<String,Object> getAllLanguage(){
    	
    	long count=languageRepo.count();
    	Map<String,Object>map=new HashMap<>();
    	map.put("count", count);
    	return map;
    }
    //language api end
   
    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

//    @PostMapping("/login")
//    public String loginUser(@RequestParam String email,
//                            @RequestParam String pwd,
//                            Model model,HttpSession session) {
//    	Student user = studentService.loginUser(email, pwd);
//    	session.setAttribute("userEmail", email);
//    	session.setAttribute("userName", user.getName());
//    	user.setLoginTime(LocalDateTime.now());
//        String emails = (String) session.getAttribute("userEmail");
//       System.out.println(emails);
//       System.out.println("Name from session: " + session.getAttribute("userName"));
//        if (user != null) {
//        	studentRepository.save(user);
//            model.addAttribute("user", user);
//            return "welcome";
//        }
//        model.addAttribute("error", "Invalid email or password!");
//        return "login";
//    }
    @PostMapping("/login")
    public String loginUser(@RequestParam String email,
                            @RequestParam String pwd,
                            Model model,
                            HttpSession session) {

        Student user = studentService.loginUser(email, pwd);

        if (user != null) {
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", user.getName());
            session.setAttribute("phoneNo", user.getPhone());
            session.setAttribute("collegeName", user.getCollegeName());
            session.setAttribute("city", user.getCity());
            session.setAttribute("state", user.getState());
            session.setAttribute("role", user.getRole());
            session.setAttribute("gender", user.getGender());
            session.setAttribute("course", user.getCourse());
            session.setAttribute("specialization", user.getSpecialization());
            session.setAttribute("passedOut", user.getPassedout());
            session.setAttribute("experience", user.getExperience());
            user.setLoginTime(LocalDateTime.now());

            studentRepository.save(user);
            model.addAttribute("user", user);
            return "welcome"; // profile.jsp
        }

        // Handle invalid login
        model.addAttribute("error", "Invalid email or password!");
        return "login"; // stays on login.jsp
    }
    @GetMapping("/Adminlogin")
    public String showAdminLoginPage() {
        return "AdminLogin";
    }
    
    @PostMapping("/Adminlogin")
    public String AdminloginUser(@RequestParam String email,
                            @RequestParam String pwd,
                            Model model,
                            HttpSession session) {

        Student user = studentService.loginUser(email, pwd);

        if (user != null) {
//            session.setAttribute("userEmail", email);
//            session.setAttribute("userName", user.getName());
//            session.setAttribute("phoneNo", user.getPhone());
//            session.setAttribute("collegeName", user.getCollegeName());
//            session.setAttribute("city", user.getCity());
//            session.setAttribute("state", user.getState());
//            session.setAttribute("role", user.getRole());
//            session.setAttribute("gender", user.getGender());
//            session.setAttribute("course", user.getCourse());
//            session.setAttribute("specialization", user.getSpecialization());
//            session.setAttribute("passedOut", user.getPassedout());
//            session.setAttribute("experience", user.getExperience());
//            user.setLoginTime(LocalDateTime.now());
//
//            studentRepository.save(user);
//            model.addAttribute("user", user);
//            return "welcome"; // profile.jsp
        	// Check if the user role is Admin
            if ("Admin".equalsIgnoreCase(user.getRole())) {
                session.setAttribute("userEmail", email);
                session.setAttribute("userName", user.getName());
                session.setAttribute("phoneNo", user.getPhone());
                session.setAttribute("collegeName", user.getCollegeName());
                session.setAttribute("city", user.getCity());
                session.setAttribute("state", user.getState());
                session.setAttribute("role", user.getRole());
                session.setAttribute("gender", user.getGender());
                session.setAttribute("course", user.getCourse());
                session.setAttribute("specialization", user.getSpecialization());
                session.setAttribute("passedOut", user.getPassedout());
                session.setAttribute("experience", user.getExperience());

                user.setLoginTime(LocalDateTime.now());
                studentRepository.save(user);

                model.addAttribute("user", user);
                return "welcome";
            } else {
                model.addAttribute("error", "Access denied! Only admins can log in.");
                return "AdminLogin";
            }
        }

        // Handle invalid login
        model.addAttribute("error", "Invalid email or password!");
        return "AdminLogin"; // stays on login.jsp
    }
//    @PostMapping("/login")
//    public String loginUser(@RequestParam String email,
//                            @RequestParam String pwd,
//                            Model model,
//                            HttpSession session,
//                            HttpServletRequest request) {
// 
////        String sebHeader = request.getHeader("X-SafeExamBrowser-ConfigKeyHash");
//// 
////        if (sebHeader == null || sebHeader.isEmpty()) {
////            model.addAttribute("error", "⚠️ You must open this exam using Safe Exam Browser!");
////            return "login";
////        }
// 
//        Student user = studentService.loginUser(email, pwd);
// 
//        if (user != null) {
// 
//            // 🔥 Check last login date
//            LocalDateTime lastLogin = user.getLoginTime();
//            LocalDateTime now = LocalDateTime.now();
// 
//            if (lastLogin != null) {
//                LocalDateTime sixMonthsAfter = lastLogin.plusMonths(6);
// 
//                // If 6 months are NOT completed → block login
//                if (now.isBefore(sixMonthsAfter)) {
//                    long monthsLeft = java.time.temporal.ChronoUnit.MONTHS.between(now, sixMonthsAfter);
// 
//                    model.addAttribute("error",
//                        "You can access again only after: " + sixMonthsAfter 
////                        " (Remaining: " + monthsLeft + " months)"
//                    );
// 
//                    return "login";
//                }
//            }
// 
//            // 🔥 First time login OR 6 months completed → allow login
//            session.setAttribute("userEmail", email);
//            session.setAttribute("userName", user.getName());
//            session.setAttribute("phoneNo", user.getPhone());
//            session.setAttribute("collegeName", user.getCollegeName());
//            session.setAttribute("city", user.getCity());
//            session.setAttribute("state", user.getState());
//            session.setAttribute("role", user.getRole());
//            session.setAttribute("gender", user.getGender());
//            session.setAttribute("course", user.getCourse());
//            session.setAttribute("specialization", user.getSpecialization());
//            session.setAttribute("passedOut", user.getPassedout());
//            session.setAttribute("experience", user.getExperience());
// 
//            // Update login time for next attempt
//            user.setLoginTime(now);
//            studentRepository.save(user);
// 
//            model.addAttribute("user", user);
//            return "welcome";
//        }
// 
//        model.addAttribute("error", "Invalid email or password!");
//        return "login";
//    }

 // 1. To open the JSP page
    @GetMapping("/forgetPassword")
    public String showForgetPasswordPage() {
        return "forgetPassword";  // forgetPassword.jsp
    }

    // 2. To handle form submission
    @PostMapping("/forget")
    public String forgetPassword(@RequestParam String email,
                                 @RequestParam String password,
                                @ModelAttribute Student student,
                                 Model model) {

        Optional<Student> student1 = studentRepository.findByEmail(email);

//        Optional<Student> student1 = studentRepository.findByRole(role);

        if (student1.isEmpty()) {
            model.addAttribute("error", "No student found with this email");
            return "forgetPassword";
        }

        Student std = student1.get();
        std.setPassword(password);
     
        studentRepository.save(std);
        System.out.println(std.getRole());

        model.addAttribute("message", "Password updated successfully. Please login!");
        if ("Admin".equalsIgnoreCase(std.getRole())) {
            return "AdminLogin";
        } else {
            return "login";
        }
  // go to login.jsp
    }
    
    
    @GetMapping("/profile")
    public String showProfile(@RequestParam("email") String email, Model model) {

        Optional<Student> optionalStudent = studentRepository.findByEmail(email);

        if (optionalStudent.isPresent()) {
            Student student = optionalStudent.get();
            model.addAttribute("student", student);
            return "profile";  // profile.jsp
        } else {
            model.addAttribute("error", "No student found with this email");
            return "welcome";
        }
    }
    @GetMapping("/update")
    public String showUpdateProfile() {
    	return "updateProfile";
    }
    @GetMapping("/home")
    public String showBack() {
    	return "welcome";
    }
//    @PostMapping("/editProfile")
//    public String updateProfileByemail(@RequestParam String email,@ModelAttribute Student std,HttpServletRequest request, HttpServletResponse respons){
//    	
//    	Optional<Student>student=studentRepository.findByEmail(email);
//    	if(student.isEmpty()) {
//    		request.setAttribute("msg", "Update Failed");
//    		return "profile";
//    	}
//    	studentService.registerUser(std);
//    	return "login";
//    }
    @PostMapping("/editProfile")
    public String editProfile(@ModelAttribute Student student) {
        // find existing user by email
        Optional<Student> existing = studentRepository.findByEmail(student.getEmail());

        if (existing != null) {
        	Student std=existing.get();
            // update only the editable fields
        	std.setName(student.getName());
        	std.setRole(student.getRole());
        	std.setPhone(student.getPhone());
        	std.setGender(student.getGender());
        	std.setCourse(student.getCourse());
        	std.setSpecialization(student.getSpecialization());
        	std.setPassedout(student.getPassedout());
        	std.setCollegeName(student.getCollegeName());
            std.setExperience(student.getExperience());
            std.setCity(student.getCity());
            std.setState(student.getState());

            studentRepository.save(std); // ✅ update
        } else {
            studentRepository.save(student);  // ⚠️ only if new user (optional)
        }

        if ("Admin".equalsIgnoreCase(student.getRole())) {
            return "AdminLogin";
        } else {
            return "login";
        }
 
    }

    @GetMapping("/admin1")
    public String admin1() {
        return "admin1";
    }
    @GetMapping("/dashboard")
    public String dashboard() {
        return "admin1";
    }
    @GetMapping("/manageCandidates")
    public String manageCandidates() {
        return "admin2";
    }
    @GetMapping("/candidatesPerformance")
    public String candidatesPerformance() {
        return "admin3";
    }
    @GetMapping("/feedbackReports")
    public String feedbackReports() {
        return "admin4";
    }
    @GetMapping("/examDetails")
    public String examDetails() {
        return "examDetails";
    }
//    @GetMapping("/examScreen")
//    public String examScreen() {
//        return "examScreen";
//    }
    
    
    
    
    
    
    
    //mcq post start
    
    
//    @PostMapping("/saveMcq")
//    public String saveMcq(@ModelAttribute Mcq mcq, Map<String, Object> map) {
//        mcqRepository.save(mcq); // This will save languageName, question, optionText, and correctOption
//        map.put("mcq", "Mcq's Successfully Saved");
//        return "admin6";
//    }
    
    
    
//    @PostMapping("/saveMcq")
//    public String saveMcq(@ModelAttribute Mcq mcq, Map<String, Object> map) {
//        String language = mcq.getLanguageName();
//
//        if ("Java".equalsIgnoreCase(language)) {
//            mcqRepository.save(mcq);
//
//        } else if ("Python".equalsIgnoreCase(language)) {
//            PythonMcq pythonMcq = new PythonMcq();
//            pythonMcq.setLanguageName(mcq.getLanguageName());
//            pythonMcq.setQuestion(mcq.getQuestion());
//            pythonMcq.setOptionText(mcq.getOptionText());
//            pythonMcq.setCorrectOption(mcq.getCorrectOption());
//            pythonmcqRepository.save(pythonMcq);
//
//        } else if ("React".equalsIgnoreCase(language)) {
//            ReactMcq reactMcq = new ReactMcq();
//            reactMcq.setLanguageName(mcq.getLanguageName());
//            reactMcq.setQuestion(mcq.getQuestion());
//            reactMcq.setOptionText(mcq.getOptionText());
//            reactMcq.setCorrectOption(mcq.getCorrectOption());
//            reactmcqRepository.save(reactMcq);
//
//        } else if ("Javascript".equalsIgnoreCase(language)) {
//            JavascriptMcq jsMcq = new JavascriptMcq();
//            jsMcq.setLanguageName(mcq.getLanguageName());
//            jsMcq.setQuestion(mcq.getQuestion());
//            jsMcq.setOptionText(mcq.getOptionText());
//            jsMcq.setCorrectOption(mcq.getCorrectOption());
//            javascriptmcqRepository.save(jsMcq);
//
//        } else {
//            map.put("mcq", "Invalid language selected!");
//            return "admin6";
//        }
//
//        map.put("mcq", "MCQ successfully saved in " + language + " table!");
//        return "admin6";
//    }
    
    
    @GetMapping("/getMcqsByLanguage")
    @ResponseBody
    public List<?> getMcqsByLanguage(@RequestParam String languageName,
    		@RequestParam String setName) {

    	Optional<ExamSet> optionalSet =
    		    examSetRepository
    		    .findByLanguageNameAndSetName(
    		        languageName,
    		        setName
    		    );

    		if(optionalSet.isEmpty()) {
    		    return Collections.emptyList();
    		}

    		ExamSet examSet = optionalSet.get();
    		System.out.println("CODING QUESTION ID = "
    		        + examSet.getCodingQuestionId());

    		List<Long> mcqIds = Arrays.stream(
    		        examSet.getMcqIds().split(","))
    		        .map(String::trim)
    		        .map(Long::parseLong)
    		        .toList();
    	
        if ("Java".equalsIgnoreCase(languageName)) {
         	return mcqRepository.findAllById(mcqIds);
        } else if ("Python".equalsIgnoreCase(languageName)) {
            return pythonmcqRepository.findAllById(mcqIds);
        } else if ("React".equalsIgnoreCase(languageName)) {
            return reactmcqRepository.findAllById(mcqIds);
        } else if ("Javascript".equalsIgnoreCase(languageName)) {
            return javascriptmcqRepository.findAllById(mcqIds);
        } else if ("Testing".equalsIgnoreCase(languageName)) {
            return testingmcqRepository.findAllById(mcqIds);
        }
        else if ("Php".equalsIgnoreCase(languageName)) {
            return phpmcqRepository.findAllById(mcqIds);
        }
        else if("Aws".equalsIgnoreCase(languageName)) {
        	return awsrepository.findAllById(mcqIds);
        }
        else {
            return Collections.emptyList();
        }
    }
    
    
    
    
//    @PostMapping("/updateMcq")
//    public String updateMcq(@ModelAttribute Mcq mcq, Map<String, Object> map) {
//        String language = mcq.getLanguageName();
//
//        if ("Java".equalsIgnoreCase(language)) {
//            // ✅ Find existing record by ID and update it
//            Optional<Mcq> existing = mcqRepository.findById(mcq.getId());
//            if (existing.isPresent()) {
//                Mcq existingMcq = existing.get();
//                existingMcq.setQuestion(mcq.getQuestion());
//                existingMcq.setOptionText(mcq.getOptionText());
//                existingMcq.setCorrectOption(mcq.getCorrectOption());
//                existingMcq.setLanguageName(mcq.getLanguageName());
//                mcqRepository.save(existingMcq);
//            } else {
//                map.put("mcq", "MCQ not found for update!");
//                return "admin10";
//            }
//
//        } else if ("Python".equalsIgnoreCase(language)) {
//            Optional<PythonMcq> existing = pythonmcqRepository.findById(mcq.getId());
//            if (existing.isPresent()) {
//                PythonMcq pythonMcq = existing.get();
//                pythonMcq.setQuestion(mcq.getQuestion());
//                pythonMcq.setOptionText(mcq.getOptionText());
//                pythonMcq.setCorrectOption(mcq.getCorrectOption());
//                pythonMcq.setLanguageName(mcq.getLanguageName());
//                pythonmcqRepository.save(pythonMcq);
//            } else {
//                map.put("mcq", "Python MCQ not found for update!");
//                return "admin10";
//            }
//
//        } else if ("React".equalsIgnoreCase(language)) {
//            Optional<ReactMcq> existing = reactmcqRepository.findById(mcq.getId());
//            if (existing.isPresent()) {
//                ReactMcq reactMcq = existing.get();
//                reactMcq.setQuestion(mcq.getQuestion());
//                reactMcq.setOptionText(mcq.getOptionText());
//                reactMcq.setCorrectOption(mcq.getCorrectOption());
//                reactMcq.setLanguageName(mcq.getLanguageName());
//                reactmcqRepository.save(reactMcq);
//            } else {
//                map.put("mcq", "React MCQ not found for update!");
//                return "admin10";
//            }
//
//        } else if ("Javascript".equalsIgnoreCase(language)) {
//            Optional<JavascriptMcq> existing = javascriptmcqRepository.findById(mcq.getId());
//            if (existing.isPresent()) {
//                JavascriptMcq jsMcq = existing.get();
//                jsMcq.setQuestion(mcq.getQuestion());
//                jsMcq.setOptionText(mcq.getOptionText());
//                jsMcq.setCorrectOption(mcq.getCorrectOption());
//                jsMcq.setLanguageName(mcq.getLanguageName());
//                javascriptmcqRepository.save(jsMcq);
//            } else {
//                map.put("mcq", "Javascript MCQ not found for update!");
//                return "admin10";
//            }
//
//        } else {
//            map.put("mcq", "Invalid language selected!");
//            return "admin10";
//        }
//
//        map.put("mcq", "MCQ successfully updated in " + language + " table!");
//        return "admin10";
//    }
    /*@PostMapping("/saveMcq")
    public String saveMcq(
            @RequestParam("languageName") String languageName,
            @RequestParam("question") String question,
            @RequestParam("optionsJson") String optionsJson,           // CHANGED: Now JSON array
            @RequestParam("correctOption") String correctOption,
            Map<String, Object> map) {

        System.out.println("Received MCQ Data (Save):");
        System.out.println("Language: " + languageName);
        System.out.println("Question: " + question);
        System.out.println("Correct Option: " + correctOption);
        System.out.println("Raw optionsJson: " + optionsJson);

        // Parse JSON array of options - Safe from commas, quotes, newlines
        List<String> optionList = new ArrayList<>();
        try {
            ObjectMapper mapper = new ObjectMapper();
            optionList = mapper.readValue(optionsJson, new TypeReference<List<String>>(){});
        } catch (Exception e) {
            e.printStackTrace();
            map.put("mcq", "Error parsing options. Please try again.");
            return "admin6";
        }

        String formattedOptionText = formatOptionsSafely(optionList);

        System.out.println("Formatted Options: " + formattedOptionText);

        // Optional<Language>lang= languageRepo.findByLanguageName(language);
        // String langua= lang.get().getLanguageName();

        if ("Java".equalsIgnoreCase(languageName)) {
            Mcq mcq = new Mcq();
            mcq.setLanguageName(languageName);
            mcq.setQuestion(question);
            mcq.setOptionText(formattedOptionText);
            mcq.setCorrectOption(correctOption);
            mcqRepository.save(mcq);

            System.out.println("Saved Java MCQ Data:");
            System.out.println("Question: " + mcq.getQuestion());
            System.out.println("Options: " + mcq.getOptionText());
            System.out.println("Correct Option: " + mcq.getCorrectOption());
            System.out.println("Language: " + mcq.getLanguageName());

        } else if ("Python".equalsIgnoreCase(languageName)) {
            PythonMcq pythonMcq = new PythonMcq();
            pythonMcq.setLanguageName(languageName);
            pythonMcq.setQuestion(question);
            pythonMcq.setOptionText(formattedOptionText);
            pythonMcq.setCorrectOption(correctOption);
            pythonmcqRepository.save(pythonMcq);

            System.out.println("Saved Python MCQ Data:");
            System.out.println("Question: " + pythonMcq.getQuestion());
            System.out.println("Options: " + pythonMcq.getOptionText());
            System.out.println("Correct Option: " + pythonMcq.getCorrectOption());
            System.out.println("Language: " + pythonMcq.getLanguageName());

        } else if ("React".equalsIgnoreCase(languageName)) {
            ReactMcq reactMcq = new ReactMcq();
            reactMcq.setLanguageName(languageName);
            reactMcq.setQuestion(question);
            reactMcq.setOptionText(formattedOptionText);
            reactMcq.setCorrectOption(correctOption);
            reactmcqRepository.save(reactMcq);

            System.out.println("Saved React MCQ Data:");
            System.out.println("Question: " + reactMcq.getQuestion());
            System.out.println("Options: " + reactMcq.getOptionText());
            System.out.println("Correct Option: " + reactMcq.getCorrectOption());
            System.out.println("Language: " + reactMcq.getLanguageName());

        } else if ("Javascript".equalsIgnoreCase(languageName)) {
            JavascriptMcq jsMcq = new JavascriptMcq();
            jsMcq.setLanguageName(languageName);
            jsMcq.setQuestion(question);
            jsMcq.setOptionText(formattedOptionText);
            jsMcq.setCorrectOption(correctOption);
            javascriptmcqRepository.save(jsMcq);

            System.out.println("Saved Javascript MCQ Data:");
            System.out.println("Question: " + jsMcq.getQuestion());
            System.out.println("Options: " + jsMcq.getOptionText());
            System.out.println("Correct Option: " + jsMcq.getCorrectOption());
            System.out.println("Language: " + jsMcq.getLanguageName());

        } else if ("Testing".equalsIgnoreCase(languageName)) {
            TestingMcq tsMcq = new TestingMcq();
            tsMcq.setLanguageName(languageName);
            tsMcq.setQuestion(question);
            tsMcq.setOptionText(formattedOptionText);
            tsMcq.setCorrectOption(correctOption);
            testingmcqRepository.save(tsMcq);

            System.out.println("Saved Testing MCQ Data:");
            System.out.println("Question: " + tsMcq.getQuestion());
            System.out.println("Options: " + tsMcq.getOptionText());
            System.out.println("Correct Option: " + tsMcq.getCorrectOption());
            System.out.println("Language: " + tsMcq.getLanguageName());

        } else {
            map.put("mcq", "Invalid language selected!");
            System.out.println("Error: Invalid language selected - " + languageName);
            return "admin6";
        }

        map.put("mcq", "MCQ successfully saved in " + languageName + " table!");
        System.out.println("MCQ successfully saved in " + languageName + " table!");
        return "admin6";
    }*/
    
    @GetMapping("/checkMcqLimit")
    @ResponseBody
    public Map<String, Object> checkMcqLimit(@RequestParam("languageName") String languageName) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            System.out.println("Checking MCQ limit for language: " + languageName);
            
            // Validate language
            if (!"java".equalsIgnoreCase(languageName) &&
                    !"python".equalsIgnoreCase(languageName) &&
                    !"react".equalsIgnoreCase(languageName) &&
                    !"javascript".equalsIgnoreCase(languageName) &&
                    !"php".equalsIgnoreCase(languageName) &&
                    !"aws".equalsIgnoreCase(languageName) &&
                    !"testing".equalsIgnoreCase(languageName)) {
                response.put("limitReached", false);
                response.put("error", "Invalid language selected");
                return response;
            }
            
            // Fetch totalMcq from ManageExam based on language
            List<ManageExam> manageExams = manageexamRepoository.findByLanguageName(languageName);
            
            if (manageExams == null || manageExams.isEmpty()) {
                response.put("limitReached", false);
                response.put("error", "Exam configuration not found for " + languageName);
                return response;
            }
            
            ManageExam manageExam = manageExams.get(manageExams.size() - 1);
            int totalMcq = 1000;                                                      //mcq limit 
            
            // Count existing MCQs for this language based on the repository
            int existingCount = 0;
            
            switch (languageName.toLowerCase()) {
                case "java":
                    existingCount = mcqRepository.countByLanguageName(languageName);
                    break;
                case "python":
                    existingCount = pythonmcqRepository.countByLanguageName(languageName);
                    break;
                case "react":
                    existingCount = reactmcqRepository.countByLanguageName(languageName);
                    break;
                case "php":
                    existingCount = phpmcqRepository.countByLanguageName(languageName);
                    break;
                case "aws":
                	existingCount = awsrepository.countByLanguageName(languageName);
                	break;
                case "javascript":
                    existingCount = javascriptmcqRepository.countByLanguageName(languageName);
                    break;
                case "testing":
                    existingCount = testingmcqRepository.countByLanguageName(languageName);
                    break;
            }
            
            System.out.println("Language: " + languageName +
                             ", Existing Count: " + existingCount +
                             ", Total Allowed: " + totalMcq);
            
            // Check if MCQ limit is reached
            boolean limitReached = existingCount >= totalMcq;
            
            response.put("limitReached", limitReached);
            response.put("currentCount", existingCount);
            response.put("totalAllowed", totalMcq);
            response.put("languageName", languageName);
            
            return response;
            
        } catch (Exception e) {
            e.printStackTrace();
            response.put("limitReached", false);
            response.put("error", "Error checking MCQ limit: " + e.getMessage());
            return response;
        }
    }
    
    @PostMapping("/saveMcq")
    public String saveMcq(
            @RequestParam("languageName") String languageName,
            @RequestParam("question") String question,
            @RequestParam("optionsJson") String optionsJson,
            @RequestParam("correctOption") String correctOption,
            Map<String, Object> map) {
 
        System.out.println("Received MCQ Data (Save):");
        System.out.println("Language: " + languageName);
        System.out.println("Question: " + question);
        System.out.println("Correct Option: " + correctOption);
        System.out.println("Raw optionsJson: " + optionsJson);
 
        // Validate language
        if (!"java".equalsIgnoreCase(languageName) &&
                !"python".equalsIgnoreCase(languageName) &&
                !"react".equalsIgnoreCase(languageName) &&
                !"php".equalsIgnoreCase(languageName) &&
                !"aws".equalsIgnoreCase(languageName) &&
                !"javascript".equalsIgnoreCase(languageName) &&
                !"testing".equalsIgnoreCase(languageName)) {
            map.put("mcq", "Invalid language selected!");
            System.out.println("Error: Invalid language selected - " + languageName);
            return "admin6";
        }
 
        // Fetch totalMcq from ManageExam based on language
        List<ManageExam> manageExams = manageexamRepoository.findByLanguageName(languageName);
        
        if (manageExams == null || manageExams.isEmpty()) {
            map.put("mcq", "Exam configuration not found for " + languageName + "!");
            System.out.println("Error: Exam configuration not found for - " + languageName);
            return "admin6";
        }
        
        ManageExam manageExam = manageExams.get(manageExams.size() - 1);
        int totalMcq = manageExam.getTotalMcq();
        
        // Count existing MCQs for this language
        int existingCount = 0;
        
        switch (languageName.toLowerCase()) {
            case "java":
                existingCount = mcqRepository.countByLanguageName(languageName);
                break;
            case "python":
                existingCount = pythonmcqRepository.countByLanguageName(languageName);
                break;
            case "react":
                existingCount = reactmcqRepository.countByLanguageName(languageName);
                break;
            case "php":
                existingCount = phpmcqRepository.countByLanguageName(languageName);
                break;
            case "aws":
            	existingCount = awsrepository.countByLanguageName(languageName);
            	break;
            case "javascript":
                existingCount = javascriptmcqRepository.countByLanguageName(languageName);
                break;
            case "testing":
                existingCount = testingmcqRepository.countByLanguageName(languageName);
                break;
        }
 
        // Check if MCQ limit is reached
        if (existingCount >= totalMcq) {
            map.put("mcq", "You cannot add more MCQs. Limit of " + totalMcq + " reached for " + languageName + ".");
            System.out.println("MCQ limit reached for: " + languageName);
            return "admin6";
        }
 
        // Parse JSON array of options
        List<String> optionList = new ArrayList<>();
        try {
            ObjectMapper mapper = new ObjectMapper();
            optionList = mapper.readValue(optionsJson, new TypeReference<List<String>>(){});
        } catch (Exception e) {
            e.printStackTrace();
            map.put("mcq", "Error parsing options. Please try again.");
            return "admin6";
        }
 
        String formattedOptionText = formatOptionsSafely(optionList);
 
        System.out.println("Formatted Options: " + formattedOptionText);
 
        // Save MCQ based on language
        try {
            switch (languageName.toLowerCase()) {
                case "java":
                    Mcq mcq = new Mcq();
                    mcq.setLanguageName(languageName);
                    mcq.setQuestion(question);
                    mcq.setOptionText(formattedOptionText);
                    mcq.setCorrectOption(correctOption);
                    mcqRepository.save(mcq);
 
                    System.out.println("Saved Java MCQ Data:");
                    System.out.println("Question: " + mcq.getQuestion());
                    System.out.println("Options: " + mcq.getOptionText());
                    System.out.println("Correct Option: " + mcq.getCorrectOption());
                    System.out.println("Language: " + mcq.getLanguageName());
                    break;
                    
                case "python":
                    PythonMcq pythonMcq = new PythonMcq();
                    pythonMcq.setLanguageName(languageName);
                    pythonMcq.setQuestion(question);
                    pythonMcq.setOptionText(formattedOptionText);
                    pythonMcq.setCorrectOption(correctOption);
                    pythonmcqRepository.save(pythonMcq);
 
                    System.out.println("Saved Python MCQ Data:");
                    System.out.println("Question: " + pythonMcq.getQuestion());
                    System.out.println("Options: " + pythonMcq.getOptionText());
                    System.out.println("Correct Option: " + pythonMcq.getCorrectOption());
                    System.out.println("Language: " + pythonMcq.getLanguageName());
                    break;
                    
                case "react":
                    ReactMcq reactMcq = new ReactMcq();
                    reactMcq.setLanguageName(languageName);
                    reactMcq.setQuestion(question);
                    reactMcq.setOptionText(formattedOptionText);
                    reactMcq.setCorrectOption(correctOption);
                    reactmcqRepository.save(reactMcq);
 
                    System.out.println("Saved React MCQ Data:");
                    System.out.println("Question: " + reactMcq.getQuestion());
                    System.out.println("Options: " + reactMcq.getOptionText());
                    System.out.println("Correct Option: " + reactMcq.getCorrectOption());
                    System.out.println("Language: " + reactMcq.getLanguageName());
                    break;
                    
                case "php":
                    PhpMcq phpMcq = new PhpMcq();
                    phpMcq.setLanguageName(languageName);
                    phpMcq.setQuestion(question);
                    phpMcq.setOptionText(formattedOptionText);
                    phpMcq.setCorrectOption(correctOption);
                    phpmcqRepository.save(phpMcq);
 
                    System.out.println("Saved Php MCQ Data:");
                    System.out.println("Question: " + phpMcq.getQuestion());
                    System.out.println("Options: " + phpMcq.getOptionText());
                    System.out.println("Correct Option: " + phpMcq.getCorrectOption());
                    System.out.println("Language: " + phpMcq.getLanguageName());
                    break;
                    
                case "aws":
                	AwsMcq awsMcq = new AwsMcq();
                	awsMcq.setLanguageName(languageName);
                	awsMcq.setQuestion(question);
                	awsMcq.setOptionText(formattedOptionText);
                	awsMcq.setCorrectOption(correctOption);
                	awsrepository.save(awsMcq);
                	
                	 System.out.println("Saved Aws MCQ Data:");
                     System.out.println("Question: " +  awsMcq.getQuestion());
                     System.out.println("Options: " +  awsMcq.getOptionText());
                     System.out.println("Correct Option: " +  awsMcq.getCorrectOption());
                     System.out.println("Language: " +  awsMcq.getLanguageName());
                     break;
                	
                    
                case "javascript":
                    JavascriptMcq jsMcq = new JavascriptMcq();
                    jsMcq.setLanguageName(languageName);
                    jsMcq.setQuestion(question);
                    jsMcq.setOptionText(formattedOptionText);
                    jsMcq.setCorrectOption(correctOption);
                    javascriptmcqRepository.save(jsMcq);
 
                    System.out.println("Saved Javascript MCQ Data:");
                    System.out.println("Question: " + jsMcq.getQuestion());
                    System.out.println("Options: " + jsMcq.getOptionText());
                    System.out.println("Correct Option: " + jsMcq.getCorrectOption());
                    System.out.println("Language: " + jsMcq.getLanguageName());
                    break;
                    
                case "testing":
                    TestingMcq tsMcq = new TestingMcq();
                    tsMcq.setLanguageName(languageName);
                    tsMcq.setQuestion(question);
                    tsMcq.setOptionText(formattedOptionText);
                    tsMcq.setCorrectOption(correctOption);
                    testingmcqRepository.save(tsMcq);
 
                    System.out.println("Saved Testing MCQ Data:");
                    System.out.println("Question: " + tsMcq.getQuestion());
                    System.out.println("Options: " + tsMcq.getOptionText());
                    System.out.println("Correct Option: " + tsMcq.getCorrectOption());
                    System.out.println("Language: " + tsMcq.getLanguageName());
                    break;
            }
 
            map.put("mcq", "MCQ successfully saved in " + languageName + " table!");
            System.out.println("MCQ successfully saved in " + languageName + " table!");
            
        } catch (Exception e) {
            map.put("mcq", "Error saving MCQ: " + e.getMessage());
            System.out.println("Error saving MCQ: " + e.getMessage());
            return "admin6";
        }
 
        return "admin6";
    }
    
//    @PostMapping("/saveMcq")
//    public String saveMcq(@ModelAttribute Mcq mcq, Map<String, Object> map) {
//        String language = mcq.getLanguageName();
//        String formattedOptionText = formatOptions(mcq.getOptionText());
//
//        
//        System.out.println("Received MCQ Data (Save):");
//        System.out.println("Language: " + mcq.getLanguageName());
//        System.out.println("Question: " + mcq.getQuestion());
//        System.out.println("Options: " + formattedOptionText);
//        System.out.println("Correct Option: " + mcq.getCorrectOption());
//
////       Optional<Language>lang= languageRepo.findByLanguageName(language);
////        
////       String langua= lang.get().getLanguageName();
//       
//        if ("Java".equalsIgnoreCase(language)) {
//            mcq.setOptionText(formattedOptionText);
//            mcqRepository.save(mcq);
//            System.out.println("Saved Java MCQ Data:");
//            System.out.println("Question: " + mcq.getQuestion());
//            System.out.println("Options: " + mcq.getOptionText());
//            System.out.println("Correct Option: " + mcq.getCorrectOption());
//            System.out.println("Language: " + mcq.getLanguageName());
//
//        } else if ("Python".equalsIgnoreCase(language)) {
//            PythonMcq pythonMcq = new PythonMcq();
//            pythonMcq.setLanguageName(mcq.getLanguageName());
//            pythonMcq.setQuestion(mcq.getQuestion());
//            pythonMcq.setOptionText(formattedOptionText);
//            pythonMcq.setCorrectOption(mcq.getCorrectOption());
//            pythonmcqRepository.save(pythonMcq);
//            System.out.println("Saved Python MCQ Data:");
//            System.out.println("Question: " + pythonMcq.getQuestion());
//            System.out.println("Options: " + pythonMcq.getOptionText());
//            System.out.println("Correct Option: " + pythonMcq.getCorrectOption());
//            System.out.println("Language: " + pythonMcq.getLanguageName());
//
//        } else if ("React".equalsIgnoreCase(language)) {
//            ReactMcq reactMcq = new ReactMcq();
//            reactMcq.setLanguageName(mcq.getLanguageName());
//            reactMcq.setQuestion(mcq.getQuestion());
//            reactMcq.setOptionText(formattedOptionText);
//            reactMcq.setCorrectOption(mcq.getCorrectOption());
//            reactmcqRepository.save(reactMcq);
//            System.out.println("Saved React MCQ Data:");
//            System.out.println("Question: " + reactMcq.getQuestion());
//            System.out.println("Options: " + reactMcq.getOptionText());
//            System.out.println("Correct Option: " + reactMcq.getCorrectOption());
//            System.out.println("Language: " + reactMcq.getLanguageName());
//
//        } else if ("Javascript".equalsIgnoreCase(language)) {
//            JavascriptMcq jsMcq = new JavascriptMcq();
//            jsMcq.setLanguageName(mcq.getLanguageName());
//            jsMcq.setQuestion(mcq.getQuestion());
//            jsMcq.setOptionText(formattedOptionText);
//            jsMcq.setCorrectOption(mcq.getCorrectOption());
//            javascriptmcqRepository.save(jsMcq);
//            System.out.println("Saved Javascript MCQ Data:");
//            System.out.println("Question: " + jsMcq.getQuestion());
//            System.out.println("Options: " + jsMcq.getOptionText());
//            System.out.println("Correct Option: " + jsMcq.getCorrectOption());
//            System.out.println("Language: " + jsMcq.getLanguageName());
//
//        } else if ("Testing".equalsIgnoreCase(language)) {
//        	TestingMcq tsMcq = new TestingMcq();
//        	tsMcq.setLanguageName(mcq.getLanguageName());
//        	tsMcq.setQuestion(mcq.getQuestion());
//        	tsMcq.setOptionText(formattedOptionText);
//        	tsMcq.setCorrectOption(mcq.getCorrectOption());
//        	testingmcqRepository.save(tsMcq);
//            System.out.println("Saved Javascript MCQ Data:");
//            System.out.println("Question: " + tsMcq.getQuestion());
//            System.out.println("Options: " + tsMcq.getOptionText());
//            System.out.println("Correct Option: " + tsMcq.getCorrectOption());
//            System.out.println("Language: " + tsMcq.getLanguageName());
//
//        }
//        else {
//            map.put("mcq", "Invalid language selected!");
//            System.out.println("Error: Invalid language selected - " + language);
//            return "admin6";
//        }
//
//        map.put("mcq", "MCQ successfully saved in " + language + " table!");
//        System.out.println("MCQ successfully saved in " + language + " table!");
//        return "admin6";
//    }

//    @PostMapping("/updateMcq")
//    public String updateMcq(@ModelAttribute Mcq mcq, Map<String, Object> map) {
//        String language = mcq.getLanguageName();
//        String formattedOptionText = formatOptions(mcq.getOptionText());
//
//        // Print incoming MCQ data
//        System.out.println("Received MCQ Data (Update):");
//        System.out.println("ID: " + mcq.getId());
//        System.out.println("Language: " + mcq.getLanguageName());
//        System.out.println("Question: " + mcq.getQuestion());
//        System.out.println("Options: " + formattedOptionText);
//        System.out.println("Correct Option: " + mcq.getCorrectOption());
//
//        if ("Java".equalsIgnoreCase(language)) {
//            Optional<Mcq> existing = mcqRepository.findById(mcq.getId());
//            if (existing.isPresent()) {
//                Mcq existingMcq = existing.get();
//                existingMcq.setQuestion(mcq.getQuestion());
//                existingMcq.setOptionText(formattedOptionText);
//                existingMcq.setCorrectOption(mcq.getCorrectOption());
//                existingMcq.setLanguageName(mcq.getLanguageName());
//                mcqRepository.save(existingMcq);
//
//                // Print updated MCQ data
//                System.out.println("Updated Java MCQ Data:");
//                System.out.println("ID: " + existingMcq.getId());
//                System.out.println("Question: " + existingMcq.getQuestion());
//                System.out.println("Options: " + existingMcq.getOptionText());
//                System.out.println("Correct Option: " + existingMcq.getCorrectOption());
//                System.out.println("Language: " + existingMcq.getLanguageName());
//            } else {
//                map.put("mcq", "MCQ not found for update!");
//                System.out.println("Error: Java MCQ with ID " + mcq.getId() + " not found!");
//                return "admin10";
//            }
//
//        } else if ("Python".equalsIgnoreCase(language)) {
//            Optional<PythonMcq> existing = pythonmcqRepository.findById(mcq.getId());
//            if (existing.isPresent()) {
//                PythonMcq pythonMcq = existing.get();
//                pythonMcq.setQuestion(mcq.getQuestion());
//                pythonMcq.setOptionText(formattedOptionText);
//                pythonMcq.setCorrectOption(mcq.getCorrectOption());
//                pythonMcq.setLanguageName(mcq.getLanguageName());
//                pythonmcqRepository.save(pythonMcq);
//
//                // Print updated Python MCQ data
//                System.out.println("Updated Python MCQ Data:");
//                System.out.println("ID: " + pythonMcq.getId());
//                System.out.println("Question: " + pythonMcq.getQuestion());
//                System.out.println("Options: " + pythonMcq.getOptionText());
//                System.out.println("Correct Option: " + pythonMcq.getCorrectOption());
//                System.out.println("Language: " + pythonMcq.getLanguageName());
//            } else {
//                map.put("mcq", "Python MCQ not found for update!");
//                System.out.println("Error: Python MCQ with ID " + mcq.getId() + " not found!");
//                return "admin10";
//            }
//
//        } else if ("React".equalsIgnoreCase(language)) {
//            Optional<ReactMcq> existing = reactmcqRepository.findById(mcq.getId());
//            if (existing.isPresent()) {
//                ReactMcq reactMcq = existing.get();
//                reactMcq.setQuestion(mcq.getQuestion());
//                reactMcq.setOptionText(formattedOptionText);
//                reactMcq.setCorrectOption(mcq.getCorrectOption());
//                reactMcq.setLanguageName(mcq.getLanguageName());
//                reactmcqRepository.save(reactMcq);
//
//                // Print updated React MCQ data
//                System.out.println("Updated React MCQ Data:");
//                System.out.println("ID: " + reactMcq.getId());
//                System.out.println("Question: " + reactMcq.getQuestion());
//                System.out.println("Options: " + reactMcq.getOptionText());
//                System.out.println("Correct Option: " + reactMcq.getCorrectOption());
//                System.out.println("Language: " + reactMcq.getLanguageName());
//            } else {
//                map.put("mcq", "React MCQ not found for update!");
//                System.out.println("Error: React MCQ with ID " + mcq.getId() + " not found!");
//                return "admin10";
//            }
//
//        } else if ("Testing".equalsIgnoreCase(language)) {
//            Optional<TestingMcq> existing = testingmcqRepository.findById(mcq.getId());
//            if (existing.isPresent()) {
//                TestingMcq testingMcq = existing.get();
//                testingMcq.setQuestion(mcq.getQuestion());
//                testingMcq.setOptionText(formattedOptionText);
//                testingMcq.setCorrectOption(mcq.getCorrectOption());
//                testingMcq.setLanguageName(mcq.getLanguageName());
//                testingmcqRepository.save(testingMcq);
//
//                // Print updated React MCQ data
//                System.out.println("Updated React MCQ Data:");
//                System.out.println("ID: " + testingMcq.getId());
//                System.out.println("Question: " + testingMcq.getQuestion());
//                System.out.println("Options: " + testingMcq.getOptionText());
//                System.out.println("Correct Option: " + testingMcq.getCorrectOption());
//                System.out.println("Language: " + testingMcq.getLanguageName());
//            } else {
//                map.put("mcq", "React MCQ not found for update!");
//                System.out.println("Error: React MCQ with ID " + mcq.getId() + " not found!");
//                return "admin10";
//            }
//
//        } else if ("Javascript".equalsIgnoreCase(language)) {
//            Optional<JavascriptMcq> existing = javascriptmcqRepository.findById(mcq.getId());
//            if (existing.isPresent()) {
//                JavascriptMcq jsMcq = existing.get();
//                jsMcq.setQuestion(mcq.getQuestion());
//                jsMcq.setOptionText(formattedOptionText);
//                jsMcq.setCorrectOption(mcq.getCorrectOption());
//                jsMcq.setLanguageName(mcq.getLanguageName());
//                javascriptmcqRepository.save(jsMcq);
//
//                // Print updated Javascript MCQ data
//                System.out.println("Updated Javascript MCQ Data:");
//                System.out.println("ID: " + jsMcq.getId());
//                System.out.println("Question: " + jsMcq.getQuestion());
//                System.out.println("Options: " + jsMcq.getOptionText());
//                System.out.println("Correct Option: " + jsMcq.getCorrectOption());
//                System.out.println("Language: " + jsMcq.getLanguageName());
//            } else {
//                map.put("mcq", "Javascript MCQ not found for update!");
//                System.out.println("Error: Javascript MCQ with ID " + mcq.getId() + " not found!");
//                return "admin10";
//            }
//
//        } else {
//            map.put("mcq", "Invalid language selected!");
//            System.out.println("Error: Invalid language selected - " + language);
//            return "admin9";
//        }
//
//        map.put("mcq", "MCQ successfully updated in " + language + " table!");
//        System.out.println("MCQ successfully updated in " + language + " table!");
//        return "admin9";
//    }
    @PostMapping("/updateMcq")
    public String updateMcq(
            @RequestParam("id") Long id,
            @RequestParam("languageName") String languageName,
            @RequestParam("question") String question,
            @RequestParam("optionsJson") String optionsJson,
            @RequestParam("correctOption") String correctOption,
            Map<String, Object> map) {

        System.out.println("Received MCQ Update Request:");
        System.out.println("ID: " + id);
        System.out.println("Language: " + languageName);
        System.out.println("Question: " + question);
        System.out.println("Correct Option: " + correctOption);
        System.out.println("Raw optionsJson: " + optionsJson);

        // Parse JSON array of options
        List<String> optionList = new ArrayList<>();
        try {
            ObjectMapper mapper = new ObjectMapper();
            optionList = mapper.readValue(optionsJson, new TypeReference<List<String>>() {});
        } catch (Exception e) {
            e.printStackTrace();
            map.put("mcq", "Error parsing options during update.");
            return "admin10";
        }

        String formattedOptionText = formatOptionsSafely(optionList);
        System.out.println("Formatted Options: " + formattedOptionText);

        boolean updated = false;
        String tableName = languageName;

        if ("Java".equalsIgnoreCase(languageName)) {
            Optional<Mcq> optional = mcqRepository.findById(id);
            if (optional.isPresent()) {
                Mcq mcq = optional.get();
                mcq.setQuestion(question);
                mcq.setOptionText(formattedOptionText);
                mcq.setCorrectOption(correctOption);
                mcqRepository.save(mcq);
                updated = true;
                System.out.println("Updated Java MCQ ID: " + id);
            }
        }
        else if ("Python".equalsIgnoreCase(languageName)) {
            Optional<PythonMcq> optional = pythonmcqRepository.findById(id);
            if (optional.isPresent()) {
                PythonMcq mcq = optional.get();
                mcq.setQuestion(question);
                mcq.setOptionText(formattedOptionText);
                mcq.setCorrectOption(correctOption);
                pythonmcqRepository.save(mcq);
                updated = true;
            }
        }
        else if ("React".equalsIgnoreCase(languageName)) {
            Optional<ReactMcq> optional = reactmcqRepository.findById(id);
            if (optional.isPresent()) {
                ReactMcq mcq = optional.get();
                mcq.setQuestion(question);
                mcq.setOptionText(formattedOptionText);
                mcq.setCorrectOption(correctOption);
                reactmcqRepository.save(mcq);
                updated = true;
            }
        }
        else if ("Php".equalsIgnoreCase(languageName)) {
            Optional<PhpMcq> optional = phpmcqRepository.findById(id);
            if (optional.isPresent()) {
                PhpMcq mcq = optional.get();
                mcq.setQuestion(question);
                mcq.setOptionText(formattedOptionText);
                mcq.setCorrectOption(correctOption);
                phpmcqRepository.save(mcq);
                updated = true;
            }
        }
        else if ("Aws".equalsIgnoreCase(languageName)) {
            Optional<AwsMcq> optional = awsrepository.findById(id);
            if (optional.isPresent()) {
                AwsMcq mcq = optional.get();
                mcq.setQuestion(question);
                mcq.setOptionText(formattedOptionText);
                mcq.setCorrectOption(correctOption);
                awsrepository.save(mcq);
                updated = true;
            }
        }
        else if ("Javascript".equalsIgnoreCase(languageName)) {
            Optional<JavascriptMcq> optional = javascriptmcqRepository.findById(id);
            if (optional.isPresent()) {
                JavascriptMcq mcq = optional.get();
                mcq.setQuestion(question);
                mcq.setOptionText(formattedOptionText);
                mcq.setCorrectOption(correctOption);
                javascriptmcqRepository.save(mcq);
                updated = true;
            }
        }
        else if ("Testing".equalsIgnoreCase(languageName)) {
            Optional<TestingMcq> optional = testingmcqRepository.findById(id);
            if (optional.isPresent()) {
                TestingMcq mcq = optional.get();
                mcq.setQuestion(question);
                mcq.setOptionText(formattedOptionText);
                mcq.setCorrectOption(correctOption);
                testingmcqRepository.save(mcq);
                updated = true;
            }
        }
        else {
            map.put("mcq", "Invalid language selected!");
            return "admin10";
        }

        if (updated) {
            map.put("mcq", "MCQ successfully updated in " + tableName + " table!");
            System.out.println("MCQ successfully updated in " + tableName + " table!");
            return "admin9"; // Adjust to your success redirect
        } else {
            map.put("mcq", "MCQ not found with ID: " + id + " in " + tableName);
            System.out.println("Update failed: MCQ not found ID " + id + " in " + tableName);
            return "admin10";
        }
    }

//    private String formatOptions(String optionText) {
//        if (optionText == null || optionText.trim().isEmpty()) {
//            return "a. None, b. None, c. None, d. None";
//        }
//        String[] options = optionText.split(",");
//        List<String> formattedOptions = new ArrayList<>();
//        int optionCount = 0;
//        for (int i = 0; i < options.length && optionCount < 4; i++) {
//            String opt = options[i].trim();
//            if (!opt.isEmpty()) {
//                if (!opt.matches("^[a-z]\\..*")) {
//                    opt = (char) (97 + optionCount) + ". " + opt;
//                }
//                formattedOptions.add(opt);
//                optionCount++;
//            }
//        }
//        while (formattedOptions.size() < 4) {
//            formattedOptions.add((char) (97 + formattedOptions.size()) + ". None");
//        }
//        while (formattedOptions.size() > 4) {
//            formattedOptions.remove(formattedOptions.size() - 1);
//        }
//        return String.join(", ", formattedOptions);
//    }
    private String formatOptionsSafely(List<String> options) {
        List<String> formatted = new ArrayList<>();
        int maxOptions = Math.min(options.size(), 10); // safe limit

        for (int i = 0; i < maxOptions; i++) {
            String opt = options.get(i).trim();
            if (!opt.isEmpty()) {
                char label = (char) ('a' + i);
                formatted.add(label + ". " + opt);
            }
        }

        // Always ensure at least 4 options
        while (formatted.size() < 4) {
            char label = (char) ('a' + formatted.size());
            formatted.add(label + ". None");
        }

        return String.join(", ", formatted);
    }

    
    
    

    //mcq post end
    //mcq update start
//    @PostMapping("/updateMcq")
//    public String updateMcq(@RequestParam Long id, @ModelAttribute Mcq mcq, Map<String,Object>map) {
//        Mcq existMcq = mcqRepository.findById(id).get();
//        
//        if (existMcq != null) {
//            
//            existMcq.setLanguageName(mcq.getLanguageName());
//            existMcq.setQuestion(mcq.getQuestion());
//            existMcq.setOptionText(mcq.getOptionText());
//            existMcq.setCorrectOption(mcq.getCorrectOption());
//            
//            
//            mcqRepository.save(existMcq);
//            map.put("mcq", "MCQ Successfully Updated");
//        } else {
//            map.put("mcq", "MCQ Not Found with ID: " + id);
//        }
//        
//        return "map";
//    }



    //mcq update end
    
//    @GetMapping("/examScreen")
//    public String examScreen(@RequestParam String languageName, Model model) {
//        model.addAttribute("languageName", languageName);
//        return "examScreen";
//    }
    
    @GetMapping("/examScreen")
    public String examScreen(
            @RequestParam String languageName,
            @RequestParam String questionSet,
            Model model) {

        Optional<ExamSet> optionalSet =
                examSetRepository
                .findByLanguageNameAndSetName(
                        languageName,
                        questionSet);

        if(optionalSet.isEmpty()) {

            model.addAttribute(
                    "mcq",
                    new ArrayList<>());

            model.addAttribute(
                    "questions",
                    new ArrayList<>());

            return "examScreen";
        }

        ExamSet examSet = optionalSet.get();

        List<Long> mcqIds =
                Arrays.stream(
                        examSet.getMcqIds().split(","))
                        .map(String::trim)
                        .map(Long::parseLong)
                        .toList();

        List<?> mcqQuestions =
                new ArrayList<>();

        if ("Java".equalsIgnoreCase(languageName)) {

            mcqQuestions =
                    mcqRepository.findAllById(mcqIds);

        } else if ("Python".equalsIgnoreCase(languageName)) {

            mcqQuestions =
                    pythonmcqRepository.findAllById(mcqIds);

        } else if ("React".equalsIgnoreCase(languageName)) {

            mcqQuestions =
                    reactmcqRepository.findAllById(mcqIds);

        } else if ("Javascript".equalsIgnoreCase(languageName)) {

            mcqQuestions =
                    javascriptmcqRepository.findAllById(mcqIds);

        } else if ("Testing".equalsIgnoreCase(languageName)) {

            mcqQuestions =
                    testingmcqRepository.findAllById(mcqIds);

        } else if ("Php".equalsIgnoreCase(languageName)) {

            mcqQuestions =
                    phpmcqRepository.findAllById(mcqIds);

        } else if ("Aws".equalsIgnoreCase(languageName)) {

            mcqQuestions =
                    awsrepository.findAllById(mcqIds);
        }

        model.addAttribute("mcq", mcqQuestions);

        List<CodingQuestions> questions =
                new ArrayList<>();

        Long codingQuestionId =
                examSet.getCodingQuestionId();

        System.out.println(
                "CODING QUESTION ID = "
                + codingQuestionId);

        CodingQuestions codingQuestion =
                codingRepository
                .findById(codingQuestionId)
                .orElse(null);

        System.out.println(
                "CODING QUESTION = "
                + codingQuestion);

        if(codingQuestion != null) {
            questions.add(codingQuestion);
        }

        model.addAttribute("questions", questions);
        model.addAttribute("languageName", languageName);
        model.addAttribute("setName", questionSet);

        return "examScreen";
    }

    // MCQ endpoint
//    @GetMapping("/examScreen/mcq")
//    public String examMcqScreen(@RequestParam String languageName, Model model) {
//        List<Mcq> questions = mcqRepository.findByLanguageName(languageName);
//        model.addAttribute("mcq", questions);
//        model.addAttribute("languageName", languageName);
//        return "examScreen";
//    }
//    @GetMapping("/examScreen/mcq")
//    public String examMcqScreen(@RequestParam String languageName, Model model) {
//
//        if ("Java".equalsIgnoreCase(languageName)) {
//            List<Mcq> questions = mcqRepository.findByLanguageName(languageName);
//            model.addAttribute("mcq", questions);
//
//        } else if ("Python".equalsIgnoreCase(languageName)) {
//            List<PythonMcq> questions = pythonmcqRepository.findAll();
//            model.addAttribute("mcq", questions);
//
//        } else if ("React".equalsIgnoreCase(languageName)) {
//            List<ReactMcq> questions = reactmcqRepository.findAll();
//            model.addAttribute("mcq", questions);
//
//        }else if ("Php".equalsIgnoreCase(languageName)) {
//            List<PhpMcq> questions = phpmcqRepository.findAll();
//            model.addAttribute("mcq", questions);
//
//        
//    }else if ("Aws".equalsIgnoreCase(languageName)) {
//        List<AwsMcq> questions = awsrepository.findAll();
//        model.addAttribute("mcq", questions);
//
//    }
//        else if ("Javascript".equalsIgnoreCase(languageName)) {
//            List<JavascriptMcq> questions = javascriptmcqRepository.findAll();
//            model.addAttribute("mcq", questions);
//
//        } else if ("Testing".equalsIgnoreCase(languageName)) {
//            List<TestingMcq> questions = testingmcqRepository.findAll();
//            model.addAttribute("mcq", questions);
//
//        } else {
//            model.addAttribute("mcq", null);
//        }
//
//        model.addAttribute("languageName", languageName);
//        return "examScreen";
//    }


    // Coding endpoint
//    @GetMapping("/examScreen/coding")
//    public String examCodingScreen(@RequestParam String languageName, Model model) {
//        List<CodingQuestions> questions = codingRepository.findByLanguageName(languageName);
//        model.addAttribute("questions", questions);
//        model.addAttribute("languageName", languageName);
//        return "examScreen";
//    }
    
//    @GetMapping("/examScreen/coding")
//    public String examCodingScreen(
//            @RequestParam String languageName,
//            @RequestParam String setName,
//            Model model) {
//
//        Optional<ExamSet> optionalSet = examSetRepository.findByLanguageNameAndSetName( languageName, setName );
//
//        if(optionalSet.isEmpty()) {
//
//            model.addAttribute( "questions",new ArrayList<>());
//
//            return "examScreen";
//        }
//
//        ExamSet examSet = optionalSet.get();
//        System.out.println("CODING QUESTION ID = "
//                + examSet.getCodingQuestionId());
//
//        Long codingQuestionId =
//                examSet.getCodingQuestionId();
//
//        CodingQuestions codingQuestion =
//                codingRepository
//                .findById(codingQuestionId)
//                .orElse(null);
//
//        List<CodingQuestions> questions =
//                new ArrayList<>();
//
//        if(codingQuestion != null) {
//            questions.add(codingQuestion);
//        }
//
//        model.addAttribute("questions", questions);
//        model.addAttribute("languageName", languageName);
//        model.addAttribute("setName", setName);
//        
//        System.out.println("SET FOUND: " + examSet.getSetName());
//
//        System.out.println("CODING QUESTION ID: " + codingQuestionId);
//        System.out.println("CODING QUESTION: "+ codingQuestion);
//        System.out.println("LANGUAGE: " + languageName);
//        System.out.println("SET: " + setName);
//        System.out.println("OPTIONAL SET: " + optionalSet.isPresent());
//
//        return "examScreen";
//    }


    @GetMapping("/codingQuestions")
    public String codingQuestions() {
    	return "admin5";
    }
    @GetMapping("/mcqQuestions")
    public String mcqQuestions() {
    	return "admin6";
    }
    @GetMapping("/manageExam")
    public String manageExam() {
    	return "admin7";
    }
    @GetMapping("/updateQuestions")
    public String updateQuestions() {
    	return "admin9";
    }
    
    @GetMapping("/updateMcq")
    public String updateMcq() {
    	return "admin10";
    }
    @GetMapping("/updateCoding")
    public String updateCoding() {
    	return "admin11";
    }
    @GetMapping("/getallmcq")
    public String getallMcq() {
    	return "admin12";
    }
    @GetMapping("/getallcoding")
    public String getallCoding() {
    	return "admin13";
    }
    @GetMapping("/getallMcqWithoutAnswer")
    public String getallMcqWithoutAnswer() {
    	return "admin14";
    }
    @GetMapping("/getCodingAnswers")
    public String getCodingAnswers() {
    	return "admin20";
    }
    
    @GetMapping("getCodingById")
    public ResponseEntity<?> getCodingById(@RequestParam Long id)
    {
    	Optional<ExamScreen> examScreen = examscreenRepository.findById(id);
    	if(examScreen.isEmpty())
    	{
    		String message = "No data found with the Id: " + id;
    		return new ResponseEntity<>(message, HttpStatus.NOT_FOUND);
    	}
    	
    	ExamScreen examscreen = examScreen.get();
    	
    	Map<String, Object> response = new LinkedHashMap<>();
    	response.put("id", examscreen.getId());
    	response.put("status", examscreen.getStatus());
    	response.put("answers", examscreen.getAnswers());
    	response.put("city", examscreen.getCity());
    	response.put("collegename", examscreen.getCollegeName());
    	response.put("course", examscreen.getCourse());
    	response.put("email",examscreen.getEmail());
    	response.put("experience",examscreen.getExperience());
    	response.put("languagename",examscreen.getLanguageName());
    	response.put("codingAnswers",examscreen.getCodingAnswers());
    	return new ResponseEntity<>(response,HttpStatus.OK);
    	
    }
    @DeleteMapping("/deleteCodingById")
    public ResponseEntity deleteCodingById(@RequestParam Long id) {
    	
    	Optional<ExamScreen>screen=examscreenRepository.findById(id);
    	if(screen.isEmpty()) {
    	 return ResponseEntity.ok("data not found  ");
    			 } 	
    	examscreenRepository.deleteById(id);
      return ResponseEntity.ok("data deleted  ");
      }
    
    
    
    
    //rating start
    @GetMapping("/rating")
    public String rating() {
        return "rating";
    }
//    @PostMapping("/rating")
//    public String rating(@ModelAttribute RatingEntity rating) {
//    	ratingrepository.save(rating);
//       return "welcome";
//    
//    }
    @PostMapping("/rating")
    public String rating(@ModelAttribute RatingEntity rating, HttpSession session) {
        String name = (String) session.getAttribute("userName");
        String email = (String) session.getAttribute("userEmail");

//        System.out.println("Name: " + name);
//        System.out.println("Email: " + email);

        rating.setName(name);
        rating.setEmail(email);
        rating.setDateTime(LocalDateTime.now());

        ratingrepository.save(rating);

        return "Thankyou";
    }

    @GetMapping("/feedback")
    @ResponseBody
    public List<RatingEntity> getAll() {
        return ratingrepository.findAll();
    }
    
    
    @DeleteMapping("/feedback/{id}")
    @ResponseBody
    public String deleteFeedback(@PathVariable Long id) {
        if (ratingrepository.existsById(id)) {
            ratingrepository.deleteById(id);
            return "Feedback with ID " + id + " deleted successfully.";
        } else {
            return "Feedback with ID " + id + " not found.";
        }
    }
    //rating end
    
    
    //exam screen post start
 // MCQ exam save endpoint
//    @PostMapping("/save")
//    public String saveExamScreen(@RequestParam String languageName,
//                                 @RequestParam String email,
//                                 @RequestParam String questionId,
//                                 @RequestParam String optionName) {
//
//        ExamScreen existing = examscreenRepository.findByEmailAndLanguageName(email, languageName);
//
//        // Create JSON string for this answer
//        String newAnswer = "{\"questionId\":\"" + questionId + "\",\"answer\":\"" + optionName + "\"}";
//
//        if(existing != null) {
//            String currentAnswers = existing.getAnswers();
//            if(currentAnswers == null || currentAnswers.isEmpty()) {
//                existing.setAnswers("[" + newAnswer + "]");
//            } else {
//                currentAnswers = currentAnswers.substring(0, currentAnswers.length()-1);
//                currentAnswers += "," + newAnswer + "]";
//                existing.setAnswers(currentAnswers);
//            }
//            examscreenRepository.save(existing);
//        } else {
//            ExamScreen examScreen = new ExamScreen();
//            examScreen.setEmail(email);
//            examScreen.setLanguageName(languageName);
//            examScreen.setAnswers("[" + newAnswer + "]");
//            examscreenRepository.save(examScreen);
//        }
//
//        return "result"; // result.jsp
//    }
 // Save user answers in JSON
 // Save user's answer
//    @PostMapping("/save")
//    public String saveExamScreen(@RequestParam String languageName,
//                                 @RequestParam String email,
//                                 @RequestParam String questionId,
//                                 @RequestParam String optionName) {
//
//        ExamScreen existing = examscreenRepository.findByEmailAndLanguageName(email, languageName);
//        ObjectMapper objectMapper = new ObjectMapper();
//        List<Map<String,String>> answersList = new ArrayList<>();
//
//        // If existing answers exist, parse them
//        if(existing != null && existing.getAnswers() != null && !existing.getAnswers().isEmpty()) {
//            try {
//                answersList = objectMapper.readValue(existing.getAnswers(),
//                        new TypeReference<List<Map<String,String>>>() {});
//            } catch(Exception e) {
//                e.printStackTrace();
//            }
//        } else if(existing == null) {
//            existing = new ExamScreen();
//            existing.setEmail(email);
//            existing.setLanguageName(languageName);
//        }
//
//        // Check if question already exists in answers
//        boolean updated = false;
//        for(Map<String,String> ans : answersList) {
//            if(ans.get("questionId").equals(questionId)) {
//                ans.put("answer", optionName); // update existing answer
//                updated = true;
//                break;
//            }
//        }
//
//        // If question not found, add new
//        if(!updated) {
//            Map<String,String> newAns = new HashMap<>();
//            newAns.put("questionId", questionId);
//            newAns.put("answer", optionName);
//            answersList.add(newAns);
//        }
//
//        try {
//            existing.setAnswers(objectMapper.writeValueAsString(answersList));
//            examscreenRepository.save(existing);
//        } catch(Exception e) {
//            e.printStackTrace();
//        }
//
//        return "redirect:/student/result?email=" + email + "&languageName=" + languageName;
//    }
//    @PostMapping("/saveAll")
//    @ResponseBody
//    public String saveAll(@RequestBody List<Map<String, String>> answers,
//                          @RequestParam String email,
//                          @RequestParam String languageName) {
//
//        ExamScreen existing = examscreenRepository.findByEmailAndLanguageName(email, languageName);
//        if(existing == null) {
//            existing = new ExamScreen();
//            existing.setEmail(email);
//            existing.setLanguageName(languageName);
//        }
//
//        try {
//            ObjectMapper objectMapper = new ObjectMapper();
//            existing.setAnswers(objectMapper.writeValueAsString(answers));
//            examscreenRepository.save(existing);
//        } catch(Exception e) {
//            e.printStackTrace();
//        }
//
//        return "redirect:/student/result?email=" + email + "&languageName=" + languageName;
//    }
//    @PostMapping("/saveAll")
//    @ResponseBody
//    public String saveAll(@RequestBody List<Map<String, String>> newAnswers,
//                          @RequestParam String email,
//                          @RequestParam String languageName,
//                          HttpSession session) {
//        
//        String name = (String) session.getAttribute("userName");
//        String phone = (String) session.getAttribute("phoneNo");
//        String gender = (String) session.getAttribute("gender");
//        String city = (String) session.getAttribute("city");
//        String state = (String) session.getAttribute("state");
//        String exp = (String) session.getAttribute("experience");
//        String collegeName = (String) session.getAttribute("collegeName");
//        String role = (String) session.getAttribute("role");
//        String course = (String) session.getAttribute("course");
//        String passedOut = (String) session.getAttribute("passedOut");
//        String specilization = (String) session.getAttribute("specialization");
//
//        ExamScreen existing = examscreenRepository.findByEmailAndLanguageName(email, languageName);
//        ObjectMapper objectMapper = new ObjectMapper();
//
//        try {
//            List<Map<String, String>> allAnswers;
//
//            if (existing == null) {
//                existing = new ExamScreen();
//                existing.setEmail(email);
//                existing.setName(name);
//                existing.setPhone(phone);
//                existing.setGender(gender);
//                existing.setLanguageName(languageName);
//                existing.setCity(city);
//                existing.setState(state);
//                existing.setExperience(exp);
//                existing.setCollegeName(collegeName);
//                existing.setRole(role);
//                existing.setCourse(course);
//                existing.setPassedOut(passedOut);
//                existing.setSpecialization(specilization);
//                allAnswers = new ArrayList<>();
//            } else {
//                // Read existing answers
//                existing.setName(name);
//                existing.setPhone(phone);
//                existing.setGender(gender);
//                existing.setCity(city);
//                existing.setState(state);
//                existing.setExperience(exp);
//                existing.setCollegeName(collegeName);
//                existing.setRole(role);
//                existing.setCourse(course);
//                existing.setPassedOut(passedOut);
//                existing.setSpecialization(specilization);
//                String existingJson = existing.getAnswers();
//                if (existingJson == null || existingJson.isEmpty()) {
//                    allAnswers = new ArrayList<>();
//                } else {
//                    allAnswers = objectMapper.readValue(existingJson, new TypeReference<List<Map<String, String>>>(){});
//                }
//            }
//
//            // Merge or update answers
//            for (Map<String, String> ans : newAnswers) {
//                String qid = ans.get("questionId");
//                String value = ans.get("answer");
//
//                // Check if this question already exists
//                boolean updated = false;
//                for (Map<String, String> existingAns : allAnswers) {
//                    if (existingAns.get("questionId").equals(qid)) {
//                        existingAns.put("answer", value);
//                        updated = true;
//                        break;
//                    }
//                }
//
//                if (!updated) {
//                    allAnswers.add(ans);
//                }
//            }
//
//            // Save back
//            existing.setAnswers(objectMapper.writeValueAsString(allAnswers));
//            examscreenRepository.save(existing);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return "success";
//    }
//    @PostMapping("/saveAll")
//    @ResponseBody
//    public String saveAll(@RequestBody List<Map<String, String>> newAnswers,
//                          @RequestParam String email,
//                          @RequestParam String languageName,
//                          HttpSession session) {
//        
//        System.out.println("=== SAVE ALL CALLED ===");
//        System.out.println("Email: " + email);
//        System.out.println("Language: " + languageName);
//        System.out.println("MCQ Answers received: " + newAnswers.size());
//        
//        String name = (String) session.getAttribute("userName");
//        String phone = (String) session.getAttribute("phoneNo");
//        String gender = (String) session.getAttribute("gender");
//        String city = (String) session.getAttribute("city");
//        String state = (String) session.getAttribute("state");
//        String exp = (String) session.getAttribute("experience");
//        String collegeName = (String) session.getAttribute("collegeName");
//        String role = (String) session.getAttribute("role");
//        String course = (String) session.getAttribute("course");
//        String passedOut = (String) session.getAttribute("passedOut");
//        String specilization = (String) session.getAttribute("specialization");
//
//        ExamScreen existing = examscreenRepository.findByEmailAndLanguageName(email, languageName);
//        ObjectMapper objectMapper = new ObjectMapper();
//
//        try {
//            List<Map<String, String>> allAnswers;
//
//            if (existing == null) {
//                existing = new ExamScreen();
//                existing.setEmail(email);
//                existing.setName(name);
//                existing.setPhone(phone);
//                existing.setGender(gender);
//                existing.setLanguageName(languageName);
//                existing.setCity(city);
//                existing.setState(state);
//                existing.setExperience(exp);
//                existing.setCollegeName(collegeName);
//                existing.setRole(role);
//                existing.setCourse(course);
//                existing.setPassedOut(passedOut);
//                existing.setSpecialization(specilization);
//                allAnswers = new ArrayList<>();
//            } else {
//                // Read existing answers
//                existing.setName(name);
//                existing.setPhone(phone);
//                existing.setGender(gender);
//                existing.setCity(city);
//                existing.setState(state);
//                existing.setExperience(exp);
//                existing.setCollegeName(collegeName);
//                existing.setRole(role);
//                existing.setCourse(course);
//                existing.setPassedOut(passedOut);
//                existing.setSpecialization(specilization);
//                String existingJson = existing.getAnswers();
//                if (existingJson == null || existingJson.isEmpty()) {
//                    allAnswers = new ArrayList<>();
//                } else {
//                    allAnswers = objectMapper.readValue(existingJson, new TypeReference<List<Map<String, String>>>(){});
//                }
//            }
//
//            // Merge or update answers
//            for (Map<String, String> ans : newAnswers) {
//                String qid = ans.get("questionId");
//                String value = ans.get("answer");
//
//                // Check if this question already exists
//                boolean updated = false;
//                for (Map<String, String> existingAns : allAnswers) {
//                    if (existingAns.get("questionId").equals(qid)) {
//                        existingAns.put("answer", value);
//                        updated = true;
//                        break;
//                    }
//                }
//
//                if (!updated) {
//                    allAnswers.add(ans);
//                }
//            }
//
//            // Save back
//            existing.setAnswers(objectMapper.writeValueAsString(allAnswers));
//            examscreenRepository.save(existing);
//
//            System.out.println("MCQ Answers saved successfully. Total answers: " + allAnswers.size());
//
//        } catch (Exception e) {
//            System.out.println("Error saving MCQ answers: " + e.getMessage());
//            e.printStackTrace();
//        }
//
//        System.out.println("=== SAVE ALL COMPLETED ===");
//        return "success";
//    }
    
    @PostMapping("/saveAll")
    @ResponseBody
    public String saveAll(
            @RequestBody List<Map<String, String>> newAnswers,
            @RequestParam String email,
            @RequestParam String languageName,
            @RequestParam String questionSet,
            HttpSession session) {

        System.out.println("=== SAVE ALL CALLED ===");

        System.out.println("Email: " + email);

        System.out.println("Language: " + languageName);

        System.out.println(
                "MCQ Answers Received: "
                        + newAnswers.size());

        ObjectMapper objectMapper =
                new ObjectMapper();

        try {

            // =========================
            // FIND EXISTING RECORD
            // =========================

            ExamScreen existing =
                    examscreenRepository
                    .findByEmailAndLanguageName(
                            email,
                            languageName
                    );

            // =========================
            // CREATE NEW RECORD IF NULL
            // =========================

            if (existing == null) {

                existing = new ExamScreen();

                existing.setEmail(email);

                existing.setLanguageName(languageName);
                
                existing.setLoginTime(LocalDateTime.now());
            }

            // =========================
            // UPDATE USER INFO
            // =========================

            existing.setName(
                    (String) session.getAttribute(
                            "userName"));

            existing.setPhone(
                    (String) session.getAttribute(
                            "phoneNo"));

            existing.setGender(
                    (String) session.getAttribute(
                            "gender"));

            existing.setCity(
                    (String) session.getAttribute(
                            "city"));

            existing.setState(
                    (String) session.getAttribute(
                            "state"));

            existing.setExperience(
                    (String) session.getAttribute(
                            "experience"));

            existing.setCollegeName(
                    (String) session.getAttribute(
                            "collegeName"));

            existing.setRole(
                    (String) session.getAttribute(
                            "role"));

            existing.setCourse(
                    (String) session.getAttribute(
                            "course"));

            existing.setPassedOut(
                    (String) session.getAttribute(
                            "passedOut"));

            existing.setSpecialization(
                    (String) session.getAttribute(
                            "specialization"));

            // =========================
            // READ EXISTING ANSWERS
            // =========================

            List<Map<String, String>> allAnswers =
                    new ArrayList<>();

            if (existing.getAnswers() != null
                    && !existing.getAnswers().isEmpty()) {

                allAnswers =
                        objectMapper.readValue(
                                existing.getAnswers(),
                                new TypeReference<
                                        List<Map<String, String>>>() {}
                        );
            }

            // =========================
            // MERGE ANSWERS
            // =========================

            for (Map<String, String> ans : newAnswers) {

                String qid =
                        ans.get("questionId");

                String value =
                        ans.get("answer");

                boolean updated = false;

                for (Map<String, String> existingAns
                        : allAnswers) {

                    if (existingAns
                            .get("questionId")
                            .equals(qid)) {

                        existingAns.put(
                                "answer",
                                value);

                        updated = true;

                        break;
                    }
                }

                if (!updated) {

                    allAnswers.add(ans);
                }
            }

            // =========================
            // SAVE FINAL JSON
            // =========================

            existing.setAnswers(
                    objectMapper
                            .writeValueAsString(
                                    allAnswers));

            examscreenRepository.save(existing);

            System.out.println(
                    "MCQ Answers Saved Successfully");

            System.out.println(
                    "Total Answers: "
                            + allAnswers.size());

        } catch (Exception e) {

            System.out.println(
                    "ERROR SAVING MCQ ANSWERS");

            e.printStackTrace();

            return "error";
        }

        System.out.println(
                "=== SAVE ALL COMPLETED ===");

        return "success";
    }
    
//    @PostMapping("/saveAll")
//    @ResponseBody
//    public String saveAll(@RequestBody List<Map<String, String>> newAnswers,
//                          @RequestParam String email,
//                          @RequestParam String languageName,
//                          HttpSession session) {
//    	
//    	
//    	String name = (String) session.getAttribute("userName");
//    	String phone = (String) session.getAttribute("phoneNo");
//    	String gender = (String) session.getAttribute("gender");
//    	String city = (String) session.getAttribute("city");
//    	String state = (String) session.getAttribute("state");
////    	System.out.println("stae is..."+state);
//    	String exp = (String) session.getAttribute("experience");
//    	String collegeName = (String) session.getAttribute("collegeName");
//    	String role = (String) session.getAttribute("role");
//    	String course = (String) session.getAttribute("course");
//    	String passedOut = (String) session.getAttribute("passedOut");
//    	String specilization = (String) session.getAttribute("specialization");
//
//        ExamScreen existing = examscreenRepository.findByEmailAndLanguageName(email, languageName);
//        ObjectMapper objectMapper = new ObjectMapper();
//
//        try {
//            List<Map<String, String>> allAnswers;
//
//            if (existing == null) {
//                existing = new ExamScreen();
//                existing.setEmail(email);
//                existing.setName(name);
//                existing.setPhone(phone);
//                existing.setGender(gender);
//                existing.setLanguageName(languageName);
//                existing.setCity(city);
//                existing.setState(state);
//                existing.setExperience(exp);
//                existing.setCollegeName(collegeName);
//                existing.setRole(role);
//                existing.setCourse(course);
//                existing.setPassedOut(passedOut);
//                existing.setSpecialization(specilization);
//           //     existing.setMarks(null);
//                allAnswers = new ArrayList<>();
//            } else {
//                // Read existing answers
//            	existing.setName(name);
//            	existing.setPhone(phone);
//            	existing.setGender(gender);
//            	existing.setCity(city);
//            	existing.setState(state);
//            	existing.setExperience(exp);
//            	existing.setCollegeName(collegeName);
//            	existing.setRole(role);
//            	existing.setCourse(course);
//            	existing.setPassedOut(passedOut);
//            	existing.setSpecialization(specilization);
//                String existingJson = existing.getAnswers();
//                if (existingJson == null || existingJson.isEmpty()) {
//                    allAnswers = new ArrayList<>();
//                } else {
//                    allAnswers = objectMapper.readValue(existingJson, new TypeReference<List<Map<String, String>>>(){});
//                }
//            }
//
//            // Merge or update answers
//            for (Map<String, String> ans : newAnswers) {
//                String qid = ans.get("questionId");
//                String value = ans.get("answer");
//
//                // Check if this question already exists
//                boolean updated = false;
//                for (Map<String, String> existingAns : allAnswers) {
//                    if (existingAns.get("questionId").equals(qid)) {
//                        existingAns.put("answer", value);
//                        updated = true;
//                        break;
//                    }
//                }
//
//                if (!updated) {
//                    allAnswers.add(ans);
//                }
//            }
//            for (Map<String, String> ans : allAnswers) {
//                System.out.println("Question ID: " + ans.get("questionId") + ", Answer: " + ans.get("answer"));
//            }
//
////          Integer Marks=  existing.getMarks();
////            
////          System.out.println(Marks);
////         if(Marks>=50) {
////       	  existing.setStatus("PASS");
////         }
////         else {
////        	  existing.setStatus("FAILED");
//// 
////          }
//            
//            
//            
//            // Save back
//            existing.setAnswers(objectMapper.writeValueAsString(allAnswers));
//            examscreenRepository.save(existing);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return "success";
//    }
//    @PostMapping("/saveAll")
//    @ResponseBody
//    public String saveAll(@RequestBody List<Map<String, String>> newAnswers,
//                          @RequestParam String email,
//                          @RequestParam String languageName) {
//
//        ExamScreen existing = examscreenRepository.findByEmailAndLanguageName(email, languageName);
//        ObjectMapper objectMapper = new ObjectMapper();
//
//        try {
//            List<Map<String, String>> allAnswers;
//
//            if (existing == null) {
//                existing = new ExamScreen();
//                existing.setEmail(email);
//                existing.setLanguageName(languageName);
//                allAnswers = new ArrayList<>();
//            } else {
//                String existingJson = existing.getAnswers();
//                if (existingJson == null || existingJson.isEmpty()) {
//                    allAnswers = new ArrayList<>();
//                } else {
//                    allAnswers = objectMapper.readValue(existingJson, new TypeReference<List<Map<String, String>>>(){});
//                }
//            }
//
//            // Merge or update answers
//            for (Map<String, String> ans : newAnswers) {
//                String qid = ans.get("questionId");
//                String value = ans.get("answer");
//
//                boolean updated = false;
//                for (Map<String, String> existingAns : allAnswers) {
//                    if (existingAns.get("questionId").equals(qid)) {
//                        existingAns.put("answer", value);
//                        updated = true;
//                        break;
//                    }
//                }
//
//                if (!updated) {
//                    allAnswers.add(ans);
//                }
//            }
//
//            // Print all answers
//            for (Map<String, String> ans : allAnswers) {
//                System.out.println("Question ID: " + ans.get("questionId") + ", Answer: " + ans.get("answer"));
//            }
//
//            // Calculate marks
//            int mcqMarks = 0;
//            int totalMcqQuestions = allAnswers.size(); // assuming all are MCQs
//            for (Map<String, String> ans : allAnswers) {
//                String answer = ans.get("answer");
//                if ("a".equalsIgnoreCase(answer)) { // adjust according to correct answers
//                    mcqMarks += 1;
//                }
//            }
//
//            int codingMarks = 0; // static as per your requirement
//            int totalMarks = totalMcqQuestions + 0; // total possible marks (MCQ + Coding)
//
//            // Calculate percentage
//            double percentage = totalMarks > 0 ? ((double)(mcqMarks + codingMarks) * 100 / totalMarks) : 0;
//
//            System.out.println("MCQ Marks: " + mcqMarks);
//            System.out.println("Coding Marks: " + codingMarks);
//            System.out.println("Total Marks: " + totalMarks);
//            System.out.println("Percentage: " + percentage);
//
//            existing.setMarks(mcqMarks + codingMarks);
//
//            // Set pass/fail based on >=50%
//            if (percentage >= 50) {
//                existing.setStatus("PASS");
//            } else {
//                existing.setStatus("FAILED");
//            }
//
//            existing.setAnswers(objectMapper.writeValueAsString(allAnswers));
//            examscreenRepository.save(existing);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return "success";
//    }


    // Calculate marks
//    @GetMapping("/result")
//    public String calculateResult(@RequestParam String email,
//                                  @RequestParam String languageName,
//                                  @RequestParam(required = false, defaultValue = "0") int codingMarks,
//                                  @RequestParam(required = false, defaultValue = "0") int totalMarks,
//                                  Model model) {
//
//        System.out.println("=== STARTING RESULT CALCULATION ===");
//        System.out.println("Email: " + email);
//        System.out.println("Language: " + languageName);
//        System.out.println("Received Coding Marks: " + codingMarks);
//        System.out.println("Received Total Marks Parameter: " + totalMarks);
//
//        ExamScreen examScreen = examscreenRepository.findByEmailAndLanguageName(email, languageName);
//        
//        if (examScreen == null) {
//            System.out.println("No exam screen found for user");
//            model.addAttribute("marks", 0);
//            model.addAttribute("codingMarks", 0);
//            model.addAttribute("totalMarks", 0);
//            model.addAttribute("message", "No exam data found!");
//            return "result";
//        }
//
//        // Calculate MCQ marks
//        int mcqMarks = 0;
//        int totalMcqQuestions = 0;
//        
//        if (examScreen.getAnswers() != null) {
//            String answersJson = examScreen.getAnswers();
//            ObjectMapper objectMapper = new ObjectMapper();
//            List<Map<String,String>> userAnswers = new ArrayList<>();
//            try {
//                userAnswers = objectMapper.readValue(answersJson, new TypeReference<List<Map<String,String>>>(){});
//            } catch(Exception e) { 
//                e.printStackTrace(); 
//            }
//
//            System.out.println("User answers found: " + userAnswers.size());
//
//            if ("Java".equalsIgnoreCase(languageName)) {
//                List<Mcq> mcqList = mcqRepository.findByLanguageName(languageName);
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            } else if ("Python".equalsIgnoreCase(languageName)) {
//                List<PythonMcq> mcqList = pythonmcqRepository.findAll();
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            } else if ("React".equalsIgnoreCase(languageName)) {
//                List<ReactMcq> mcqList = reactmcqRepository.findAll();
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            } else if ("Javascript".equalsIgnoreCase(languageName)) {
//                List<JavascriptMcq> mcqList = javascriptmcqRepository.findAll();
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            } else if ("Testing".equalsIgnoreCase(languageName)) {
//                List<TestingMcq> mcqList = testingmcqRepository.findAll();
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            }
//        }
//
//        // Get coding marks from the database or parameter
//        int finalCodingMarks = examScreen.getCodingMarks() != null ? examScreen.getCodingMarks() : codingMarks;
//        int totalPossibleCodingMarks = 30; // easy=5 + medium=10 + hard=15
//        
//        // Calculate percentages
//        double mcqPercentage = totalMcqQuestions > 0 ? (mcqMarks * 100.0 / totalMcqQuestions) : 0;
//        double codingPercentage = totalPossibleCodingMarks > 0 ? (finalCodingMarks * 100.0 / totalPossibleCodingMarks) : 0;
//        
//        // Calculate final score with 50% weight for MCQ and 50% for Coding
//        double scorePercentage = (mcqPercentage * 0.5) + (codingPercentage * 0.5);
//        
//        System.out.println("=== MARKS BREAKDOWN ===");
//        System.out.println("MCQ Marks: " + mcqMarks + "/" + totalMcqQuestions + " = " + mcqPercentage + "%");
//        System.out.println("Coding Marks: " + finalCodingMarks + "/" + totalPossibleCodingMarks + " = " + codingPercentage + "%");
//        System.out.println("Final Score: " + scorePercentage + "%");
//        
//        // Update exam screen with calculated marks
//        examScreen.setMarks(mcqMarks);
//        examScreen.setCodingMarks(finalCodingMarks);
//        examScreen.setTotalMarks(mcqMarks + finalCodingMarks);
//        
//        // Set status based on weighted percentage (same as JSP logic)
//        String status;
//        if (scorePercentage >= 50) {
//            status = "PASS";
//        } else {
//            status = "FAILED";
//        }
//        examScreen.setStatus(status);
//        
//        examscreenRepository.save(examScreen);
//
//        System.out.println("=== FINAL RESULT SUMMARY ===");
//        System.out.println("Email: " + email);
//        System.out.println("Language: " + languageName);
//        System.out.println("MCQ Marks: " + mcqMarks + "/" + totalMcqQuestions);
//        System.out.println("Coding Marks: " + finalCodingMarks + "/" + totalPossibleCodingMarks);
//        System.out.println("Final Score: " + scorePercentage + "%");
//        System.out.println("Status: " + status);
//        System.out.println("=== END RESULT SUMMARY ===");
//
//        model.addAttribute("marks", mcqMarks);
//        model.addAttribute("codingMarks", finalCodingMarks);
//        model.addAttribute("totalMarks", totalMcqQuestions); // This should be total MCQ questions, not total marks
//        model.addAttribute("languageName", languageName);
//        model.addAttribute("status", status);
//        model.addAttribute("scorePercentage", scorePercentage);
//        
//        return "result";
//    }
//    @GetMapping("/result")
//    public String calculateResult(@RequestParam String email,
//                                  @RequestParam String languageName,
//                                  @RequestParam(required = false, defaultValue = "0") int codingMarks,
//                                  @RequestParam(required = false, defaultValue = "0") int totalMarks,
//                                  Model model) {
//
//        System.out.println("=== STARTING RESULT CALCULATION ===");
//        System.out.println("Email: " + email);
//        System.out.println("Language: " + languageName);
//        System.out.println("Received Coding Marks: " + codingMarks);
//        System.out.println("Received Total Marks Parameter: " + totalMarks);
//
//        ExamScreen examScreen = examscreenRepository.findByEmailAndLanguageName(email, languageName);
//        
//        if (examScreen == null) {
//            System.out.println("No exam screen found for user");
//            model.addAttribute("marks", 0);
//            model.addAttribute("codingMarks", 0);
//            model.addAttribute("totalMarks", 0);
//            model.addAttribute("message", "No exam data found!");
//            
//            
//            return "result";
//        }
//
//        // Calculate MCQ marks
//        int mcqMarks = 0;
//        int totalMcqQuestions = 0;
//        
//        if (examScreen.getAnswers() != null) {
//            String answersJson = examScreen.getAnswers();
//            ObjectMapper objectMapper = new ObjectMapper();
//            List<Map<String,String>> userAnswers = new ArrayList<>();
//            try {
//                userAnswers = objectMapper.readValue(answersJson, new TypeReference<List<Map<String,String>>>(){});
//            } catch(Exception e) { 
//                e.printStackTrace(); 
//            }
//
//            System.out.println("User answers found: " + userAnswers.size());
//
//            if ("Java".equalsIgnoreCase(languageName)) {
//                List<Mcq> mcqList = mcqRepository.findByLanguageName(languageName);
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            } else if ("Python".equalsIgnoreCase(languageName)) {
//                List<PythonMcq> mcqList = pythonmcqRepository.findAll();
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            } else if ("React".equalsIgnoreCase(languageName)) {
//                List<ReactMcq> mcqList = reactmcqRepository.findAll();
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            }else if ("Php".equalsIgnoreCase(languageName)) {
//                List<PhpMcq> mcqList = phpmcqRepository.findAll();
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            
//        }else if ("Aws".equalsIgnoreCase(languageName)) {
//            List<AwsMcq> mcqList = awsrepository.findAll();
//            mcqMarks = calculateScore(mcqList, userAnswers);
//            totalMcqQuestions = mcqList.size();
//        }
//            else if ("Javascript".equalsIgnoreCase(languageName)) {
//                List<JavascriptMcq> mcqList = javascriptmcqRepository.findAll();
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            } else if ("Testing".equalsIgnoreCase(languageName)) {
//                List<TestingMcq> mcqList = testingmcqRepository.findAll();
//                mcqMarks = calculateScore(mcqList, userAnswers);
//                totalMcqQuestions = mcqList.size();
//            }
//        }
//
//        // Get coding marks from the database or parameter
//        int finalCodingMarks = examScreen.getCodingMarks() != null ? examScreen.getCodingMarks() : codingMarks;
//     // Fetch marks config for this language
//        List<ManageExam> examConfigList = manageexamRepoository.findByLanguageName(languageName);
//
//        int totalPossibleCodingMarks = 0;
//
//        if (!examConfigList.isEmpty()) {
//            ManageExam config = examConfigList.get(0);
//
//            totalPossibleCodingMarks =
//                    config.getEasyLevelMarks()
//                  + config.getMediumLevelMarks()
//                  + config.getHardLevelMarks();
//        }
//
//        System.out.println("Total possible coding marks (from DB): " + totalPossibleCodingMarks);
//
//        
//        // Calculate percentages
//        double mcqPercentage = totalMcqQuestions > 0 ? (mcqMarks * 100.0 / totalMcqQuestions) : 0;
//        double codingPercentage = totalPossibleCodingMarks > 0 ? (finalCodingMarks * 100.0 / totalPossibleCodingMarks) : 0;
//        
//        // Calculate final score with 50% weight for MCQ and 50% for Coding
//        double scorePercentage = (mcqPercentage * 0.5) + (codingPercentage * 0.5);
//        
//        System.out.println("=== MARKS BREAKDOWN ===");
//        System.out.println("MCQ Marks: " + mcqMarks + "/" + totalMcqQuestions + " = " + mcqPercentage + "%");
//        System.out.println("Coding Marks: " + finalCodingMarks + "/" + totalPossibleCodingMarks + " = " + codingPercentage + "%");
//        System.out.println("Final Score: " + scorePercentage + "%");
//        
//        // Update exam screen with calculated marks
//        examScreen.setMarks(mcqMarks);
//        examScreen.setCodingMarks(finalCodingMarks);
//        examScreen.setTotalMarks(mcqMarks + finalCodingMarks);
//        
//        // Set status based on weighted percentage (same as JSP logic)
//        String status;
//        if (scorePercentage >= 50) {
//            status = "PASS";
//        } else {
//            status = "FAILED";
//        }
//        examScreen.setStatus(status);
//        
//        examscreenRepository.save(examScreen);
//
//        System.out.println("=== FINAL RESULT SUMMARY ===");
//        System.out.println("Email: " + email);
//        System.out.println("Language: " + languageName);
//        System.out.println("MCQ Marks: " + mcqMarks + "/" + totalMcqQuestions);
//        System.out.println("Coding Marks: " + finalCodingMarks + "/" + totalPossibleCodingMarks);
//        System.out.println("Final Score: " + scorePercentage + "%");
//        System.out.println("Status: " + status);
//        System.out.println("=== END RESULT SUMMARY ===");
//
//        model.addAttribute("marks", mcqMarks);
//        model.addAttribute("codingMarks", finalCodingMarks);
//        model.addAttribute("totalMarks", totalMcqQuestions);
//        model.addAttribute("languageName", languageName);
//        model.addAttribute("status", status);
//        model.addAttribute("scorePercentage", scorePercentage);
//        model.addAttribute("totalPossibleCodingMarks", totalPossibleCodingMarks);
//
//        return "result";
//    }
    
    @GetMapping("/result")
    public String calculateResult(
            @RequestParam String email,
            @RequestParam String languageName,
            @RequestParam String questionSet,
            @RequestParam(required = false, defaultValue = "0") int codingMarks,
            Model model) {

        System.out.println("=== STARTING RESULT CALCULATION ===");

        System.out.println("Email: " + email);
        System.out.println("Language: " + languageName);
        System.out.println("Question Set: " + questionSet);

        ExamScreen examScreen =
                examscreenRepository
                .findByEmailAndLanguageName(
                        email,
                        languageName
                );

        if (examScreen == null) {

            model.addAttribute("marks", 0);
            model.addAttribute("codingMarks", 0);
            model.addAttribute("totalMarks", 0);
            model.addAttribute("message", "No exam data found!");

            return "result";
        }

        // =========================
        // GET EXAM SET
        // =========================

        Optional<ExamSet> optionalSet =
                examSetRepository
                .findByLanguageNameAndSetName(
                        languageName,
                        questionSet
                );

        if (optionalSet.isEmpty()) {

            model.addAttribute("marks", 0);
            model.addAttribute("codingMarks", 0);
            model.addAttribute("totalMarks", 0);
            model.addAttribute("message", "No Exam Set Found!");

            return "result";
        }

        ExamSet examSet = optionalSet.get();

        // =========================
        // GET MCQ IDS FROM SET
        // =========================

        List<Long> mcqIds =
                Arrays.stream(
                        examSet.getMcqIds().split(","))
                        .map(String::trim)
                        .map(Long::parseLong)
                        .toList();

        // =========================
        // READ USER ANSWERS
        // =========================

        List<Map<String, String>> userAnswers =
                new ArrayList<>();

        if (examScreen.getAnswers() != null
                && !examScreen.getAnswers().isEmpty()) {

            try {

                ObjectMapper objectMapper =
                        new ObjectMapper();

                userAnswers =
                        objectMapper.readValue(
                                examScreen.getAnswers(),
                                new TypeReference<List<Map<String, String>>>() {}
                        );

            } catch (Exception e) {

                e.printStackTrace();
            }
        }

        System.out.println(
                "User Answers Count: "
                        + userAnswers.size());

        // =========================
        // CALCULATE MCQ MARKS
        // =========================

        int mcqMarks = 0;

        int totalMcqQuestions =
                mcqIds.size();

        if ("Java".equalsIgnoreCase(languageName)) {

            List<Mcq> mcqList =
                    mcqRepository.findAllById(mcqIds);

            mcqMarks =
                    calculateScore(
                            mcqList,
                            userAnswers
                    );
        }

        else if ("Python".equalsIgnoreCase(languageName)) {

            List<PythonMcq> mcqList =
                    pythonmcqRepository.findAllById(mcqIds);

            mcqMarks =
                    calculateScore(
                            mcqList,
                            userAnswers
                    );
        }

        else if ("React".equalsIgnoreCase(languageName)) {

            List<ReactMcq> mcqList =
                    reactmcqRepository.findAllById(mcqIds);

            mcqMarks =
                    calculateScore(
                            mcqList,
                            userAnswers
                    );
        }

        else if ("Javascript".equalsIgnoreCase(languageName)) {

            List<JavascriptMcq> mcqList =
                    javascriptmcqRepository.findAllById(mcqIds);

            mcqMarks =
                    calculateScore(
                            mcqList,
                            userAnswers
                    );
        }

        else if ("Testing".equalsIgnoreCase(languageName)) {

            List<TestingMcq> mcqList =
                    testingmcqRepository.findAllById(mcqIds);

            mcqMarks =
                    calculateScore(
                            mcqList,
                            userAnswers
                    );
        }

        else if ("Php".equalsIgnoreCase(languageName)) {

            List<PhpMcq> mcqList =
                    phpmcqRepository.findAllById(mcqIds);

            mcqMarks =
                    calculateScore(
                            mcqList,
                            userAnswers
                    );
        }

        else if ("Aws".equalsIgnoreCase(languageName)) {

            List<AwsMcq> mcqList =
                    awsrepository.findAllById(mcqIds);

            mcqMarks =
                    calculateScore(
                            mcqList,
                            userAnswers
                    );
        }

        // =========================
        // CODING MARKS
        // =========================

        int finalCodingMarks =
                examScreen.getCodingMarks() != null
                        ? examScreen.getCodingMarks()
                        : codingMarks;

        // =========================
        // GET CODING CONFIG
        // =========================

        List<ManageExam> examConfigList =
                manageexamRepoository
                .findByLanguageName(languageName);

        int totalPossibleCodingMarks = 0;

        if (!examConfigList.isEmpty()) {

            ManageExam config =
                    examConfigList.get(0);

            totalPossibleCodingMarks =
                    config.getEasyLevelMarks()
                            + config.getMediumLevelMarks()
                            + config.getHardLevelMarks();
        }

        // =========================
        // PERCENTAGES
        // =========================

        double mcqPercentage =
                totalMcqQuestions > 0
                        ? (mcqMarks * 100.0
                        / totalMcqQuestions)
                        : 0;

        double codingPercentage =
                totalPossibleCodingMarks > 0
                        ? (finalCodingMarks * 100.0
                        / totalPossibleCodingMarks)
                        : 0;

        double scorePercentage =
                (mcqPercentage * 0.5)
                        + (codingPercentage * 0.5);

        // =========================
        // STATUS
        // =========================

        String status =
                scorePercentage >= 50
                        ? "PASS"
                        : "FAILED";

        // =========================
        // SAVE FINAL RESULT
        // =========================

        examScreen.setMarks(mcqMarks);

        examScreen.setCodingMarks(
                finalCodingMarks);

        examScreen.setTotalMarks(
                mcqMarks + finalCodingMarks);

        examScreen.setStatus(status);

        examscreenRepository.save(examScreen);

        // =========================
        // LOGS
        // =========================

        System.out.println(
                "=== FINAL RESULT SUMMARY ===");

        System.out.println(
                "MCQ Marks: "
                        + mcqMarks
                        + "/"
                        + totalMcqQuestions);

        System.out.println(
                "Coding Marks: "
                        + finalCodingMarks
                        + "/"
                        + totalPossibleCodingMarks);

        System.out.println(
                "Final Percentage: "
                        + scorePercentage);

        System.out.println(
                "Status: "
                        + status);
        
        System.out.println(
                "totalPossibleCodingMarks: "
                        + totalPossibleCodingMarks);

        // =========================
        // SEND TO JSP
        // =========================

        model.addAttribute("marks", mcqMarks);

        model.addAttribute(
                "codingMarks",
                finalCodingMarks);

        model.addAttribute(
                "totalMarks",
                mcqMarks + finalCodingMarks);

        model.addAttribute(
                "languageName",
                languageName);

        model.addAttribute(
                "status",
                status);

        model.addAttribute(
                "scorePercentage",
                scorePercentage);

        model.addAttribute(
                "totalPossibleCodingMarks",
                totalPossibleCodingMarks);

        model.addAttribute(
                "totalPossibleMarks",
                totalMcqQuestions);


        return "result";
    }
    @PostMapping("/saveCoding")
    @ResponseBody
    public String saveCoding(@RequestBody String codingAnswersJson,
                            @RequestParam String email,
                            @RequestParam String languageName,
                            @RequestParam String questionSet,
                            @RequestParam(required = false, defaultValue = "0") int codingMarks,
                            HttpSession session) {
        
        System.out.println("=== SAVING CODING ANSWERS ===");
        System.out.println("Email: " + email);
        System.out.println("Language: " + languageName);
        System.out.println("Received Coding Marks: " + codingMarks);
        System.out.println("Coding Answers JSON Length: " + (codingAnswersJson != null ? codingAnswersJson.length() : 0));
        
        try {
            ExamScreen existing = examscreenRepository.findByEmailAndLanguageName(email, languageName);
            if (existing == null) {
                existing = new ExamScreen();
                existing.setEmail(email);
                existing.setLanguageName(languageName);
                System.out.println("Created new exam screen record");
            } else {
                System.out.println("Found existing exam screen record");
            }
            
            // Store coding answers
            existing.setCodingAnswers(codingAnswersJson);
            
            // Store coding marks
            existing.setCodingMarks(codingMarks);
            
            // Calculate total marks (MCQ + Coding)
            Integer mcqMarks = existing.getMarks();
            if (mcqMarks == null) mcqMarks = 0;
            
            int totalMarks = mcqMarks + codingMarks;
            existing.setTotalMarks(totalMarks);
            
            // Set status based on total performance
            if (totalMarks >= 50) {
                existing.setStatus("PASS");
            } else {
                existing.setStatus("FAILED");
            }
            
            examscreenRepository.save(existing);
            
            System.out.println("=== CODING DATA SAVED SUCCESSFULLY ===");
            System.out.println("MCQ Marks: " + mcqMarks);
            System.out.println("Coding Marks: " + codingMarks);
            System.out.println("Total Marks: " + totalMarks);
            System.out.println("Status: " + existing.getStatus());
            System.out.println("=== END SAVING CODING ANSWERS ===");
            
        } catch (Exception e) {
            System.out.println("=== ERROR SAVING CODING ANSWERS ===");
            e.printStackTrace();
            return "Error saving coding answers: " + e.getMessage();
        }
        
        return "success";
    }
//    @GetMapping("/result")
//    public String calculateResult(@RequestParam String email,
//                                  @RequestParam String languageName,
//                                  Model model) {
//
//        ExamScreen examScreen = examscreenRepository.findByEmailAndLanguageName(email, languageName);
//        if (examScreen == null || examScreen.getAnswers() == null) {
//            model.addAttribute("marks", 0);
//            model.addAttribute("message", "No answers found!");
//            return "result";
//        }
//
//        String answersJson = examScreen.getAnswers();
//        ObjectMapper objectMapper = new ObjectMapper();
//        List<Map<String,String>> userAnswers = new ArrayList<>();
//        try {
//            userAnswers = objectMapper.readValue(answersJson, new TypeReference<List<Map<String,String>>>(){});
//        } catch(Exception e) { e.printStackTrace(); }
//
//        int totalMarks = 0;
//
//        if ("Java".equalsIgnoreCase(languageName)) {
//            List<Mcq> mcqList = mcqRepository.findByLanguageName(languageName);
//            totalMarks = calculateScore(mcqList, userAnswers);
//        } else if ("Python".equalsIgnoreCase(languageName)) {
//            List<PythonMcq> mcqList = pythonmcqRepository.findAll();
//            totalMarks = calculateScore(mcqList, userAnswers);
//        } else if ("React".equalsIgnoreCase(languageName)) {
//            List<ReactMcq> mcqList = reactmcqRepository.findAll();
//            totalMarks = calculateScore(mcqList, userAnswers);
//        } else if ("Javascript".equalsIgnoreCase(languageName)) {
//            List<JavascriptMcq> mcqList = javascriptmcqRepository.findAll();
//            totalMarks = calculateScore(mcqList, userAnswers);
//        } else if ("Testing".equalsIgnoreCase(languageName)) {
//            List<TestingMcq> mcqList = testingmcqRepository.findAll();
//            totalMarks = calculateScore(mcqList, userAnswers);
//        }
//
//        // Store calculated marks in DB
//        examScreen.setMarks(totalMarks);
//        examscreenRepository.save(examScreen);
//
//        model.addAttribute("marks", totalMarks);
//        model.addAttribute("languageName", languageName);
//        return "result";
//    }
    
    
    @GetMapping("/all-results")
    @ResponseBody
    public List<ExamScreen> getAllResults() {
        return examscreenRepository.findAll();
    }
    
    
    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public String deleteExamById(@PathVariable Long id) {
        try {
            if (examscreenRepository.existsById(id)) {
                examscreenRepository.deleteById(id);
                return "Record deleted successfully with ID: " + id;
            } else {
                return "Record not found with ID: " + id;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error occurred while deleting record with ID: " + id;
        }
    }

    
    
    private <T> int calculateScore(List<T> mcqList, List<Map<String,String>> userAnswers) {
        int marks = 0;

        for(T mcq : mcqList) {
            String questionId = "";
            String correctOption = "";

            if(mcq instanceof Mcq) {
                questionId = String.valueOf(((Mcq)mcq).getId());
                correctOption = ((Mcq)mcq).getCorrectOption().trim();
            } else if(mcq instanceof PythonMcq) {
                questionId = String.valueOf(((PythonMcq)mcq).getId());
                correctOption = ((PythonMcq)mcq).getCorrectOption().trim();
            } else if(mcq instanceof ReactMcq) {
                questionId = String.valueOf(((ReactMcq)mcq).getId());
                correctOption = ((ReactMcq)mcq).getCorrectOption().trim();
            }else if(mcq instanceof PhpMcq) {
                questionId = String.valueOf(((PhpMcq)mcq).getId());
                correctOption = ((PhpMcq)mcq).getCorrectOption().trim();
            }
            else if(mcq instanceof AwsMcq) {
                questionId = String.valueOf(((AwsMcq)mcq).getId());
                correctOption = ((AwsMcq)mcq).getCorrectOption().trim();
            }
            else if(mcq instanceof JavascriptMcq) {
                questionId = String.valueOf(((JavascriptMcq)mcq).getId());
                correctOption = ((JavascriptMcq)mcq).getCorrectOption().trim();
            } else if(mcq instanceof TestingMcq) {
                questionId = String.valueOf(((TestingMcq)mcq).getId());
                correctOption = ((TestingMcq)mcq).getCorrectOption().trim();
            }

            for(Map<String,String> ans : userAnswers) {
                String userQid = ans.get("questionId").trim();
                String userAnswer = ans.get("answer").trim();

                if(userQid.equals(questionId) && userAnswer.equalsIgnoreCase(correctOption)) {
                    marks++;
                    break;
                }
            }
        }

        return marks;
    }
//    private <T> int calculateScore(List<T> mcqList, List<Map<String,String>> userAnswers) {
//        int marks = 0;
//
//        for(T mcq : mcqList) {
//            String questionId = "";
//            String correctOption = "";
//
//            if(mcq instanceof Mcq) {
//                questionId = String.valueOf(((Mcq)mcq).getId());
//                correctOption = ((Mcq)mcq).getCorrectOption().trim();
//            } else if(mcq instanceof PythonMcq) {
//                questionId = String.valueOf(((PythonMcq)mcq).getId());
//                correctOption = ((PythonMcq)mcq).getCorrectOption().trim();
//            } else if(mcq instanceof ReactMcq) {
//                questionId = String.valueOf(((ReactMcq)mcq).getId());
//                correctOption = ((ReactMcq)mcq).getCorrectOption().trim();
//            } else if(mcq instanceof JavascriptMcq) {
//                questionId = String.valueOf(((JavascriptMcq)mcq).getId());
//                correctOption = ((JavascriptMcq)mcq).getCorrectOption().trim();
//            } else if(mcq instanceof TestingMcq) {
//                questionId = String.valueOf(((TestingMcq)mcq).getId());
//                correctOption = ((TestingMcq)mcq).getCorrectOption().trim();
//            }
//
//            for(Map<String,String> ans : userAnswers) {
//                String userQid = ans.get("questionId").trim();
//                String userAnswer = ans.get("answer").trim();
//
//                if(userQid.equals(questionId) && userAnswer.equalsIgnoreCase(correctOption)) {
//                    marks++;
//                    break; // stop checking other answers for this question
//                }
//            }
//        }
//
//        return marks;
//    }
//    private <T> int calculateScore(List<T> mcqList, List<Map<String,String>> userAnswers) {
//        int marks = 0;
//
//        for(T mcq : mcqList) {
//            String questionId = "";
//            String correctOption = "";
//
//            if(mcq instanceof Mcq) {
//                questionId = String.valueOf(((Mcq)mcq).getId());
//                correctOption = ((Mcq)mcq).getCorrectOption().trim();
//            } else if(mcq instanceof PythonMcq) {
//                questionId = String.valueOf(((PythonMcq)mcq).getId());
//                correctOption = ((PythonMcq)mcq).getCorrectOption().trim();
//            } else if(mcq instanceof ReactMcq) {
//                questionId = String.valueOf(((ReactMcq)mcq).getId());
//                correctOption = ((ReactMcq)mcq).getCorrectOption().trim();
//            } else if(mcq instanceof JavascriptMcq) {
//                questionId = String.valueOf(((JavascriptMcq)mcq).getId());
//                correctOption = ((JavascriptMcq)mcq).getCorrectOption().trim();
//            } else if(mcq instanceof TestingMcq) {
//                questionId = String.valueOf(((TestingMcq)mcq).getId());
//                correctOption = ((TestingMcq)mcq).getCorrectOption().trim();
//            }
//
//            for(Map<String,String> ans : userAnswers) {
//                String userQid = ans.get("questionId").trim();
//                String userAnswer = ans.get("answer").trim();
//
//                if(userQid.equals(questionId) && userAnswer.equalsIgnoreCase(correctOption)) {
//                    marks++;
//                    break; // stop checking other answers for this question
//                }
//            }
//        }
//
//        return marks;
//    }



    //exam screen post end
    
  
//    @PostMapping("/runCode")
//    @ResponseBody
//    public String runCode(@RequestBody Map<String, String> payload) {
//        String language = payload.get("language");
//        String code = payload.get("code");
//        String question = payload.get("question");
//
//        try {
//            String output;
//            switch (language) {
//                case "java":
//                    output = CodeExecutor.runJava(code);
//                    break;
//                case "python":
//                    output = CodeExecutor.runPython(code);
//                    break;
//                case "cpp":
//                    output = CodeExecutor.runCpp(code);
//                    break;
//                default:
//                    return "Unsupported language!";
//            }
//
//            return "Question: " + question + "\n\nOutput:\n" + output;
//        } catch (Exception e) {
//            return "Error while running code: " + e.getMessage();
//        }
//    }
    
    
    
    
    // recently merged code start
    @GetMapping("/getallroles")
    public String getallroles() {
    	return "admin15";
    }
    @GetMapping("/getallcourses")
    public String getallcourses() {
    	return "admin16";
    }
    @GetMapping("/getallspecializations")
    public String getallspecializations() {
    	return "admin17";
    }
    @GetMapping("/getpassoutyear")
    public String getpassoutyear() {
    	return "admin18";
    }
    @GetMapping("/getalllanguages")
    public String getalllanguages() {
    	return "admin19";
    }
    @GetMapping("/getexperience")
    public String getallexperience() {
    	return "admin21";
    }
//    @PostMapping("/saveroles")
//    @ResponseBody
//    public Role saveroles(@RequestBody Role role) {
//    	
//    	
//    	return roleRepo.save(role);
//    }
    
    @PostMapping("/saveroles")
    public ResponseEntity<String> saveroles(@RequestBody Role role) {

        if (role.getRole() == null || role.getRole().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Role name cannot be empty");
        }

        String trimmed = role.getRole().trim();

        // ✅ Check duplicate
        if (!roleRepo.findByRoleIgnoreCase(trimmed).isEmpty()) {
            return ResponseEntity.badRequest().body("Role already exists");
        }

        role.setRole(trimmed);

        try {
            roleRepo.save(role);
            return ResponseEntity.ok("Role added successfully");
        } catch (Exception e) {
            // ✅ Handles DB unique constraint violation
            return ResponseEntity.badRequest().body("Role already exists (DB constraint)");
        }
    }
    @PostMapping("/savelanguages")
    @ResponseBody
    public Language savelanguages(@RequestBody Language language) {
    	return languageRepo.save(language);
    }
    @PostMapping("/savespecializations")
    @ResponseBody
    public Specialization savespecializations(@RequestBody Specialization special) {
    	return specializationRepo.save(special);
    }
    @PostMapping("/savecourse")
    @ResponseBody
    public Course savecourse(@RequestBody Course course) {
    	return courseRepository.save(course);
    }
    @PostMapping("/savepassout")
    @ResponseBody
    public PassedOut savepassout(@RequestBody PassedOut pass) {
    	return passedOutRepo.save(pass);
    }
    @PostMapping("/saveexperience")
    @ResponseBody
    public Experience saveexperience(@RequestBody Experience experience) {
    	return experienceRepo.save(experience);
    }
    @GetMapping("/role")
    public String roles() {
        return "AddRole";
    }
    @GetMapping("/getlanguages")
    public String languages() {
        return "AddLanguage";
    }
    @GetMapping("/getspecializations")
    public String specialization() {
        return "AddSpecialization";
    }
    @GetMapping("/getcourse")
    public String courses() {
        return "AddCourse";
    }
    @GetMapping("/getpassout")
    public String passout() {
        return "AddYear";
    }
    @DeleteMapping("/deleterole")
    public ResponseEntity deleterole(@RequestParam Long id) {
    	
    	Optional<Role>role=roleRepo.findById(id);
    	if(role.isEmpty()) {
    	 return ResponseEntity.ok("data not found  ");
    			 } 	
   	    roleRepo.deleteById(id);
      return ResponseEntity.ok("data deleted  ");
      }
    
    @DeleteMapping("/deletecourse")
    public ResponseEntity deletecourse(@RequestParam Long id) {
    	
    	Optional<Course>course=courseRepository.findById(id);
    	if(course.isEmpty()) {
    	 return ResponseEntity.ok("data not found  ");
    			 } 	
   	    courseRepository.deleteById(id);
      return ResponseEntity.ok("data deleted  ");
      }
    
    @DeleteMapping("/deletespecialization")
    public ResponseEntity deletespecialization(@RequestParam Long id) {
    	
    	Optional<Specialization>course=specializationRepo.findById(id);
    	if(course.isEmpty()) {
    	 return ResponseEntity.ok("data not found  ");
    			 } 	
   	   specializationRepo.deleteById(id);
      return ResponseEntity.ok("data deleted  ");
      }
    
    @DeleteMapping("/deleteyear")
    public ResponseEntity deleteyear(@RequestParam Long id) {
    	
    	Optional<PassedOut>course=passedOutRepo.findById(id);
    	if(course.isEmpty()) {
    	 return ResponseEntity.ok("data not found  ");
    			 } 	
   	   passedOutRepo.deleteById(id);
      return ResponseEntity.ok("data deleted  ");
      }
    
    
    @DeleteMapping("/deletelanguage")
    public ResponseEntity deletelanguage(@RequestParam Long id) {
    	
    	Optional<Language>course=languageRepo.findById(id);
    	if(course.isEmpty()) {
    	 return ResponseEntity.ok("data not found  ");
    			 } 	
   	   languageRepo.deleteById(id);
      return ResponseEntity.ok("data deleted  ");
      }
    @DeleteMapping("/deleteexperience")
    public ResponseEntity deleteexperience(@RequestParam Long id) {
    	
    	Optional<Experience>course=experienceRepo.findById(id);
    	if(course.isEmpty()) {
    	 return ResponseEntity.ok("data not found  ");
    			 } 	
    	experienceRepo.deleteById(id);
      return ResponseEntity.ok("data deleted  ");
      }
//    @DeleteMapping("/deleterole/{id}")
//    @ResponseBody
//    public String deleterole(@PathVariable Long id) {
//    	if(roleRepo.existsById(id)) {
//    	 roleRepo.deleteById(id);
//    	 return "Role with Id" + id + " delete Successfully";
//    	}
//    	else {
//		return "Role with Id" + id + " not Found";
//    	}
//    }
    

    @PostMapping("/editspecialization")
    public ResponseEntity<?> editspecialization(@RequestBody Specialization specialization) {

        if (specialization.getId() == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "ID is required"));
        }

        if (specialization.getDepartmentName() == null || specialization.getDepartmentName().trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("message", "Department name cannot be empty"));
        }

        Optional<Specialization> existingOpt = specializationRepo.findById(specialization.getId());
        if (!existingOpt.isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("message", "Specialization not found"));
        }

        try {
            Specialization existing = existingOpt.get();
            existing.setDepartmentName(specialization.getDepartmentName().trim());
            specializationRepo.save(existing);

            return ResponseEntity.ok(Map.of("message", "Specialization updated successfully"));
        } 
        catch (DataIntegrityViolationException e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Specialization already exists"));
        }
    }
    @PostMapping("/editrole")
    public ResponseEntity<String> editRole(@RequestBody Role role) {
try {
        if (role.getId() == null) {
            return ResponseEntity.badRequest().body("Role ID is required");
        }

        if (role.getRole() == null || role.getRole().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Role name cannot be empty");
        }

        Optional<Role> existingRoleOpt = roleRepo.findById(role.getId());
        if (!existingRoleOpt.isPresent()) {
            return ResponseEntity.badRequest().body("Role not found");
        }

        // 🔥 Get ALL roles with same name
        List<Role> duplicates = roleRepo.findAllByRole(role.getRole());

        // ❗ Check if any duplicate belongs to another ID
        boolean exists = duplicates.stream()
            .anyMatch(r -> !r.getRole().equals(role.getRole()));

        if (exists) {
            return ResponseEntity.badRequest().body("Role already exists");
        }

        Role existingRole = existingRoleOpt.get();
        existingRole.setRole(role.getRole().trim());
        roleRepo.save(existingRole);

        return ResponseEntity.ok("Role updated successfully");
    }
    catch (DataIntegrityViolationException e) {
        // ✅ Catches SQLIntegrityConstraintViolationException
        return ResponseEntity.badRequest().body("Role already exists");
    }
catch (Exception  e) {
    // ✅ Catches SQLIntegrityConstraintViolationException
    return ResponseEntity.badRequest().body("Internal Server error");
}
    }
    
    @PostMapping("/editcourse")
    public ResponseEntity<?> editCourse(@RequestBody Course course) {

        if (course.getId() == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Course ID is required"));
        }

        if (course.getCourseName() == null || course.getCourseName().trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("message", "Course name cannot be empty"));
        }

        Optional<Course> existingOpt = courseRepository.findById(course.getId());
        if (!existingOpt.isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("message", "Course not found"));
        }

        try {
            Course existing = existingOpt.get();
            existing.setCourseName(course.getCourseName().trim());
            courseRepository.save(existing);

            return ResponseEntity.ok(Map.of("message", "Course updated successfully"));
        } 
        catch (DataIntegrityViolationException e) {
            return ResponseEntity.badRequest().body(Map.of("message", "Course already exists"));
        }
    }
    @PostMapping("/edityear")
    public ResponseEntity<String> edityear(@RequestBody PassedOut passedout) {

        if (passedout.getId() == null) {
            return ResponseEntity.badRequest().body("ID is required for update");
        }

        if (passedout.getYear() == null || passedout.getYear().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Year cannot be empty");
        }

        Optional<PassedOut> existing = passedOutRepo.findById(passedout.getId());
        if (!existing.isPresent()) {
            return ResponseEntity.badRequest().body("Year not found");
        }

        String year = passedout.getYear().trim();

        // 🔥 check duplicate (ignore same record)
        boolean exists = passedOutRepo.existsByYearIgnoreCase(year);

        if (exists && !existing.get().getYear().equalsIgnoreCase(year)) {
            return ResponseEntity.badRequest().body("Year already exists");
        }

        PassedOut entity = existing.get();
        entity.setYear(year);
        passedOutRepo.save(entity);

        return ResponseEntity.ok("Year updated successfully");
    }
    @PostMapping("/editlanguage")
    public ResponseEntity<String> edityear(@RequestBody Language language) {

        if (language.getId() == null) {
            return ResponseEntity.badRequest().body("ID is required for update");
        }

        if (language.getLanguageName() == null || language.getLanguageName().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Language name cannot be empty");
        }

        Optional<Language> existing = languageRepo.findById(language.getId());
        if (!existing.isPresent()) {
            return ResponseEntity.badRequest().body("Language not found");
        }

        String name = language.getLanguageName().trim();

        // 🔥 Check duplicate (excluding same ID)
        boolean exists = languageRepo.existsByLanguageNameIgnoreCase(name);

        if (exists && !existing.get().getLanguageName().equalsIgnoreCase(name)) {
            return ResponseEntity.badRequest().body("Language already exists");
        }

        try {
            Language lang = existing.get();
            lang.setLanguageName(name);
            languageRepo.save(lang);

            return ResponseEntity.ok("Language updated successfully");
        }
        catch (DataIntegrityViolationException e) {
            return ResponseEntity.badRequest().body("Language already exists");
        }catch (Exception e) {
            return ResponseEntity.badRequest().body("Language already exists");
        }
       
    }
    @PostMapping("/editexperience")
    public ResponseEntity<String> editexperience(@RequestBody Experience experience) {

        try {
            if (experience.getId() == null) {
                return ResponseEntity.badRequest().body("Experience ID is required");
            }

            if (experience.getExperience() == null || experience.getExperience().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Experience cannot be empty");
            }

            Optional<Experience> existingOpt = experienceRepo.findById(experience.getId());
            if (!existingOpt.isPresent()) {
                return ResponseEntity.badRequest().body("Experience not found");
            }

            String trimmed = experience.getExperience().trim();

            // ✅ Check duplicate (excluding current ID)
            boolean exists = experienceRepo
                    .findByExperienceIgnoreCase(trimmed)
                    .stream()
                    .anyMatch(e -> !e.getId().equals(experience.getId()));

            if (exists) {
                return ResponseEntity.badRequest().body("Experience already exists");
            }

            Experience existing = existingOpt.get();
            existing.setExperience(trimmed);
            experienceRepo.save(existing);

            return ResponseEntity.ok("Experience updated successfully");

        } catch (DataIntegrityViolationException e) {
            return ResponseEntity.badRequest().body("Experience already exists");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Internal server error");
        }
    }

//    @PostMapping("/editrole")
//    public ResponseEntity<String> editRole(@RequestBody Role role) {
//try {
//        if (role.getId() == null) {
//            return ResponseEntity.badRequest().body("Role ID is required");
//        }
//
//        if (role.getRole() == null || role.getRole().trim().isEmpty()) {
//            return ResponseEntity.badRequest().body("Role name cannot be empty");
//        }
//
//        Optional<Role> existingRoleOpt = roleRepo.findById(role.getId());
//        if (!existingRoleOpt.isPresent()) {
//            return ResponseEntity.badRequest().body("Role not found");
//        }
//
//        // 🔥 Get ALL roles with same name
//        List<Role> duplicates = roleRepo.findAllByRole(role.getRole());
//
//        // ❗ Check if any duplicate belongs to another ID
//        boolean exists = duplicates.stream()
//            .anyMatch(r -> !r.getRole().equals(role.getRole()));
//
//        if (exists) {
//            return ResponseEntity.badRequest().body("Role already exists");
//        }
//
//        Role existingRole = existingRoleOpt.get();
//        existingRole.setRole(role.getRole().trim());
//        roleRepo.save(existingRole);
//
//        return ResponseEntity.ok("Role updated successfully");
//    }
//    catch (DataIntegrityViolationException e) {
//        // ✅ Catches SQLIntegrityConstraintViolationException
//        return ResponseEntity.badRequest().body("Role already exists");
//    }
//catch (Exception  e) {
//    // ✅ Catches SQLIntegrityConstraintViolationException
//    return ResponseEntity.badRequest().body("Internal Server error");
//}
//    }
//    @PostMapping("/editcourse")
//    public ResponseEntity<String> editCourse(@RequestBody Course course) {
//        // Validate input
//        if (course.getId() == null) {
//            return ResponseEntity.badRequest().body("Role ID is required for update");
//        }
//        if (course.getCourseName() == null || course.getCourseName().trim().isEmpty()) {
//            return ResponseEntity.badRequest().body("Role name cannot be empty");
//        }
// 
//        // Find existing role by ID
//        Optional<Course> existing =  courseRepository.findById(course.getId());
//        if (!existing.isPresent()) {
//            return ResponseEntity.badRequest().body("Role with ID " + course.getId() + " not found");
//        }
// 
//        // Update the role
//        Course existingCourse = existing.get();
//        existingCourse.setCourseName(course.getCourseName());
//        courseRepository.save(existingCourse);
// 
//        return ResponseEntity.ok("Role updated successfully");
//    }
//    
//    @PostMapping("/editspecialization")
//    public ResponseEntity<String> editspecialization(@RequestBody Specialization specialization) {
//        // Validate input
//        if (specialization.getId() == null) {
//            return ResponseEntity.badRequest().body("Role ID is required for update");
//        }
//        if (specialization.getDepartmentName() == null || specialization.getDepartmentName().trim().isEmpty()) {
//            return ResponseEntity.badRequest().body("Role name cannot be empty");
//        }
// 
//        // Find existing role by ID
//        Optional<Specialization> existing =  specializationRepo.findById(specialization.getId());
//        if (!existing.isPresent()) {
//            return ResponseEntity.badRequest().body("Role with ID " + specialization.getId() + " not found");
//        }
// 
//        // Update the role
//        Specialization existingCourse = existing.get();
//        existingCourse.setDepartmentName(specialization.getDepartmentName());
//        specializationRepo.save(existingCourse);
// 
//        return ResponseEntity.ok("Role updated successfully");
//    }
//    
//    @PostMapping("/edityear")
//    public ResponseEntity<String> edityear(@RequestBody PassedOut passedout) {
//        // Validate input
//        if (passedout.getId() == null) {
//            return ResponseEntity.badRequest().body("Role ID is required for update");
//        }
//        if (passedout.getYear() == null || passedout.getYear().trim().isEmpty()) {
//            return ResponseEntity.badRequest().body("Role name cannot be empty");
//        }
// 
//        // Find existing role by ID
//        Optional<PassedOut> existing =  passedOutRepo.findById(passedout.getId());
//        if (!existing.isPresent()) {
//            return ResponseEntity.badRequest().body("Role with ID " + passedout.getId() + " not found");
//        }
// 
//        // Update the role
//        PassedOut existingCourse = existing.get();
//        existingCourse.setYear(passedout.getYear());
//        passedOutRepo.save(existingCourse);
// 
//        return ResponseEntity.ok("Role updated successfully");
//    }
//    
//    
//    @PostMapping("/editlanguage")
//    public ResponseEntity<String> edityear(@RequestBody Language language) {
//        // Validate input
//        if (language.getId() == null) {
//            return ResponseEntity.badRequest().body("Role ID is required for update");
//        }
//        if (language.getLanguageName() == null || language.getLanguageName().trim().isEmpty()) {
//            return ResponseEntity.badRequest().body("Role name cannot be empty");
//        }
// 
//        // Find existing role by ID
//        Optional<Language> existing =  languageRepo.findById(language.getId());
//        if (!existing.isPresent()) {
//            return ResponseEntity.badRequest().body("Role with ID " + language.getId() + " not found");
//        }
// 
//        // Update the role
//        Language existingCourse = existing.get();
//        existingCourse.setLanguageName(language.getLanguageName());
//        languageRepo.save(existingCourse);
// 
//        return ResponseEntity.ok("Role updated successfully");
//    }
//    @PostMapping("/editexperience")
//    public ResponseEntity<String> editexperience(@RequestBody Experience experience) {
//        // Validate input
//        if (experience.getId() == null) {
//            return ResponseEntity.badRequest().body("Role ID is required for update");
//        }
//        if (experience.getExperience() == null || experience.getExperience().trim().isEmpty()) {
//            return ResponseEntity.badRequest().body("Role name cannot be empty");
//        }
// 
//        // Find existing role by ID
//        Optional<Experience> existing =  experienceRepo.findById(experience.getId());
//        if (!existing.isPresent()) {
//            return ResponseEntity.badRequest().body("Experience with ID " + experience.getId() + " not found");
//        }
// 
//        // Update the role
//        Experience existingExperience = existing.get();
//        existingExperience.setExperience(experience.getExperience());
//        experienceRepo.save(existingExperience);
// 
//        return ResponseEntity.ok("Role updated successfully");
//    }
    @GetMapping("/thankyou")
    public String thankYou() {
    	return "Thankyou";
    }
    
    //end
//    @GetMapping("/download/seb")
//    public ResponseEntity<?> downloadSebFile() throws IOException {
//        // Load file from classpath (inside resources/static/seb/)
//        ClassPathResource resource = new ClassPathResource("static/seb/exammodule.seb");
// 
//        if (!resource.exists()) {
//            throw new IOException("File not found in resources: static/seb/exammodule.seb");
//        }
// 
//        // Detect file content type
//        String contentType = Files.probeContentType(resource.getFile().toPath());
//        if (contentType == null) {
//            contentType = "application/octet-stream";
//        }
// 
//        // Return the file as a download response
//        return ResponseEntity.ok()
//                .contentType(MediaType.parseMediaType(contentType))
//                .header(HttpHeaders.CONTENT_DISPOSITION,
//                        "attachment; filename=\"" + resource.getFilename() + "\"")
//                .body(resource);
//    }
    
    

	@PostMapping("/quit")
    public String quitExam() {   
        System.out.println("User has quit the exam.");
        return "Quit";
    }
     @GetMapping("/quit")
     public String quitGet() {
    	 return "Quit";
     }
     
     @PostMapping("/startExam")
     public ResponseEntity<?> startExam(
             @RequestHeader("X-SafeExamBrowser-ConfigKeyHash") String configKey,
             @RequestHeader("X-SafeExamBrowser-BrowserExamKeyHash") String browserKey) {

//         String expectedConfigKey = "4d0e03c53389d3f29e5c84de6bf6de1f539353b054323205e2cd9dcf7361e0c1";
    	//// String expectedConfigKey = "5bf01b4b9eb38219c9553d063aa08b9b10403e0c307aaecaaa4b30e8c51f54b2";
//         String expectedBrowserKey = "b3d45d327bb951376ea953b050d2ac52420d98fb58b5fd4435e9ca775838393f";
////    	 String expectedBrowserKey = "71a069fa37ecf9c28b04f2fd5a3360803a1a7772b56e71d06f5581e676190b52";

    	 
    	 
    	 String expectedConfigKey = "5bf01b4b9eb38219c9553d063aa08b9b10403e0c307aaecaaa4b30e8c51f54b2";
    	 String expectedBrowserKey = "71a069fa37ecf9c28b04f2fd5a3360803a1a7772b56e71d06f5581e676190b52";

         if (!configKey.equals(expectedConfigKey)) {
             return ResponseEntity.status(403).body("Invalid SEB config");
         }

         if (!browserKey.equals(expectedBrowserKey)) {
             return ResponseEntity.status(403).body("Invalid browser key");
         }
         
         
         return ResponseEntity.status(302)
        	        .header("Location", "https://exam.nssorg.com/StudentExam/student/login")
        	        .build();

     }
     private static final Logger logger=LoggerFactory.getLogger(LayersController.class);
     
     private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
     private static final Set<String> ALLOWED_EXTENSIONS = Set.of(".xlsx", ".xls");
     
     /*@PostMapping("/uploadExcel")
     public ResponseEntity<Map<String, Object>> uploadExcel(
             @RequestParam("file") MultipartFile file,
             @RequestParam(value = "language", required = false) String languageParam) {
         
         Map<String, Object> response = new HashMap<>();
         
         try {
             // Validate file
             ValidationResult validation = validateFile(file);
             if (!validation.isValid()) {
                 response.put("success", false);
                 response.put("message", validation.getMessage());
                 return ResponseEntity.badRequest().body(response);
             }
             
             // Process Excel file and save to database
             CodingQuestions savedEntity = processAndSaveExcelFile(file, languageParam);
             
             // Build response
             Map<String, Object> data = buildResponseData(savedEntity);
             
             response.put("success", true);
             response.put("message", "Excel file uploaded and saved successfully");
             response.put("data", data);
             response.put("id", savedEntity.getId());
             
             logger.info("Excel saved successfully: id={}, language={}, easy={} test cases, medium={} test cases, hard={} test cases",
                     savedEntity.getId(),
                     savedEntity.getLanguageName(),
                     savedEntity.getEasyTestCaseCount(),
                     savedEntity.getMediumTestCaseCount(),
                     savedEntity.getHardTestCaseCount());
             
             return ResponseEntity.ok(response);
             
         } catch (InvalidFormatException e) {
             response.put("success", false);
             response.put("message", "Invalid Excel file format: " + e.getMessage());
             logger.error("Invalid Excel format: {}", e.getMessage(), e);
             return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
             
         } catch (IOException e) {
             response.put("success", false);
             response.put("message", "Error reading Excel file: " + e.getMessage());
             logger.error("IO error reading Excel: {}", e.getMessage(), e);
             return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
             
         } catch (Exception e) {
             response.put("success", false);
             response.put("message", "Unexpected error: " + e.getMessage());
             logger.error("Unexpected error processing Excel file: {}", e.getMessage(), e);
             return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
         }
     }

     private ValidationResult validateFile(MultipartFile file) {
         if (file.isEmpty()) {
             return new ValidationResult(false, "Uploaded file is empty");
         }
         
         if (file.getSize() > MAX_FILE_SIZE) {
             return new ValidationResult(false, 
                 String.format("File size exceeds maximum allowed size of %d MB", MAX_FILE_SIZE / (1024 * 1024)));
         }
         
         String filename = file.getOriginalFilename();
         if (filename == null || filename.trim().isEmpty()) {
             return new ValidationResult(false, "Invalid filename");
         }
         
         String extension = filename.substring(filename.lastIndexOf(".")).toLowerCase();
         if (!ALLOWED_EXTENSIONS.contains(extension)) {
             return new ValidationResult(false, 
                 "Invalid file format. Please upload an Excel file (.xlsx or .xls)");
         }
         
         return new ValidationResult(true, "Valid file");
     }

    
     private CodingQuestions processAndSaveExcelFile(MultipartFile file, String languageParam) 
             throws IOException, InvalidFormatException {
         
         try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
             Sheet sheet = workbook.getSheetAt(0);
             
             logger.info("Excel sheet has {} rows", sheet.getLastRowNum() + 1);
             
             if (sheet.getLastRowNum() < 1) {
                 throw new IllegalArgumentException("Excel sheet is empty or has insufficient data");
             }
             
             // Debug: Print first few rows
             debugPrintExcelRows(sheet, 5);
             
             // Extract language
             String language = languageParam;
             if (language == null || language.trim().isEmpty()) {
                 language = extractLanguageFromExcel(sheet);
                 if (language == null || language.trim().isEmpty()) {
                     language = "Unknown";
                     logger.warn("Could not extract language from Excel, using default: Unknown");
                 }
             }
             
             logger.info("Using language: {}", language);
             
          
             CodingQuestions codingQuestion = new CodingQuestions();
             codingQuestion.setLanguageName(language);
             
          
             LevelData easyData = parseLevel(sheet, "EASY");
             codingQuestion.setEasyQuestion(easyData.getQuestion());
             codingQuestion.setEasyInputArray(easyData.getInputsArray());
             codingQuestion.setEasyExpectedOutputArray(easyData.getOutputsArray());
             
         
             LevelData mediumData = parseLevel(sheet, "MEDIUM");
             codingQuestion.setMediumQuestion(mediumData.getQuestion());
             codingQuestion.setMediumInputArray(mediumData.getInputsArray());
             codingQuestion.setMediumExpectedOutputArray(mediumData.getOutputsArray());
          
             LevelData hardData = parseLevel(sheet, "HARD");
             codingQuestion.setHardQuestion(hardData.getQuestion());
             codingQuestion.setHardInputArray(hardData.getInputsArray());
             codingQuestion.setHardExpectedOutputArray(hardData.getOutputsArray());
           
             CodingQuestions savedEntity = codingRepository.save(codingQuestion);
             
             logger.info("Successfully saved coding question with id: {}", savedEntity.getId());
             
             return savedEntity;
         }
     }

   
     private String extractLanguageFromExcel(Sheet sheet) {
         // Method 1: Check first row for language
         Row firstRow = sheet.getRow(0);
         if (firstRow != null && firstRow.getCell(0) != null) {
             String cellValue = getCellValueAsString(firstRow.getCell(0)).trim();
             if (!cellValue.isEmpty() 
                 && !cellValue.equalsIgnoreCase("Difficulty") 
                 && !cellValue.equalsIgnoreCase("Question")) {
                 return cellValue;
             }
         }
         
         // Method 2: Look for language in first column
         for (int i = 0; i <= Math.min(sheet.getLastRowNum(), 20); i++) {
             Row row = sheet.getRow(i);
             if (row != null && row.getCell(0) != null) {
                 String cellValue = getCellValueAsString(row.getCell(0)).trim();
                 if (cellValue.equalsIgnoreCase("Language") && row.getCell(1) != null) {
                     return getCellValueAsString(row.getCell(1)).trim();
                 }
             }
         }
         
         return null;
     }

    
     private LevelData parseLevel(Sheet sheet, String level) {
         List<String> inputs = new ArrayList<>();
         List<String> outputs = new ArrayList<>();
         String question = "";
         boolean foundFirstQuestion = false;
         
         logger.info("=== Parsing {} level ===", level);
         
         for (int i = 1; i <= sheet.getLastRowNum(); i++) {
             Row row = sheet.getRow(i);
             if (row == null) {
                 logger.debug("Row {} is null, skipping", i);
                 continue;
             }
             
             
             Cell difficultyCell = row.getCell(1);
             if (difficultyCell == null) {
                 logger.debug("Row {}: Column B (difficulty) is null, skipping", i);
                 continue;
             }
             
             String difficulty = getCellValueAsString(difficultyCell).trim();
             logger.debug("Row {}: Difficulty = '{}'", i, difficulty);
             
             // Skip if not matching the requested level
             if (!difficulty.equalsIgnoreCase(level)) {
                 logger.debug("Row {}: Difficulty '{}' doesn't match '{}', skipping", i, difficulty, level);
                 continue;
             }
             
             logger.info("Row {}: Found matching difficulty '{}'", i, level);
             
             // Get question from column 2 (C) - only set once
             Cell questionCell = row.getCell(2);
             if (questionCell != null && !foundFirstQuestion) {
                 String questionText = getCellValueAsString(questionCell);
                 if (questionText != null && !questionText.trim().isEmpty()) {
                     question = questionText.trim();
                     foundFirstQuestion = true;
                     logger.info("Row {}: Set question = '{}'", i, question.length() > 50 ? question.substring(0, 50) + "..." : question);
                 }
             }
             
             // Get test case from columns 3 (D) and 4 (E)
             String input = "";
             String output = "";
             
             if (row.getCell(3) != null) {
                 input = getCellValueAsString(row.getCell(3)).trim();
             }
             if (row.getCell(4) != null) {
                 output = getCellValueAsString(row.getCell(4)).trim();
             }
             
             logger.debug("Row {}: Input='{}', Output='{}'", i, input, output);
             
             // Only add test case if there's content
             if (!input.isEmpty() || !output.isEmpty()) {
                 inputs.add(input);
                 outputs.add(output);
                 logger.info("Row {}: Added test case #{} - input='{}', output='{}'", i, inputs.size(), input, output);
             } else {
                 logger.warn("Row {}: Both input and output are empty, skipping test case", i);
             }
         }
         
        
         if (inputs.isEmpty()) {
             inputs.add("");
             outputs.add("");
             logger.warn("No test cases found for level: {}, added empty default", level);
         }
         
         logger.info("=== Finished parsing {}: question='{}', {} test cases ===", 
                 level, 
                 question.isEmpty() ? "[EMPTY]" : question.substring(0, Math.min(50, question.length())) + "...",
                 inputs.size());
         
         return new LevelData(question, inputs, outputs);
     }*/

     /**
      * Helper method to get cell value as string
      */
     /*private String getCellValueAsString(Cell cell) {
         if (cell == null) {
             return "";
         }
         
         try {
             switch (cell.getCellType()) {
                 case STRING:
                     return cell.getStringCellValue().trim();
                     
                 case NUMERIC:
                     if (DateUtil.isCellDateFormatted(cell)) {
                         return cell.getDateCellValue().toString();
                     } else {
                         double num = cell.getNumericCellValue();
                         if (num == Math.floor(num) && !Double.isInfinite(num)) {
                             return String.valueOf((long) num);
                         } else {
                             return String.valueOf(num);
                         }
                     }
                     
                 case BOOLEAN:
                     return String.valueOf(cell.getBooleanCellValue());
                     
                 case FORMULA:
                     try {
                         return cell.getStringCellValue();
                     } catch (Exception e) {
                         try {
                             double num = cell.getNumericCellValue();
                             if (num == Math.floor(num) && !Double.isInfinite(num)) {
                                 return String.valueOf((long) num);
                             } else {
                                 return String.valueOf(num);
                             }
                         } catch (Exception e2) {
                             return cell.getCellFormula();
                         }
                     }
                     
                 case BLANK:
                     return "";
                     
                 default:
                     return "";
             }
         } catch (Exception e) {
             logger.warn("Error reading cell value: {}", e.getMessage());
             return "";
         }
     }

    
     private Map<String, Object> buildResponseData(CodingQuestions entity) {
         Map<String, Object> data = new HashMap<>();
         data.put("id", entity.getId());
         data.put("language", entity.getLanguageName());
         
         // Easy level
         Map<String, Object> easyMap = new HashMap<>();
         easyMap.put("question", entity.getEasyQuestion());
         easyMap.put("testCases", buildTestCasesList(
             entity.getEasyInputArray(), 
             entity.getEasyExpectedOutputArray()
         ));
         data.put("easy", easyMap);
         
         // Medium level
         Map<String, Object> mediumMap = new HashMap<>();
         mediumMap.put("question", entity.getMediumQuestion());
         mediumMap.put("testCases", buildTestCasesList(
             entity.getMediumInputArray(), 
             entity.getMediumExpectedOutputArray()
         ));
         data.put("medium", mediumMap);
         
         // Hard level
         Map<String, Object> hardMap = new HashMap<>();
         hardMap.put("question", entity.getHardQuestion());
         hardMap.put("testCases", buildTestCasesList(
             entity.getHardInputArray(), 
             entity.getHardExpectedOutputArray()
         ));
         data.put("hard", hardMap);
         
         return data;
     }

   
     private List<Map<String, String>> buildTestCasesList(String[] inputs, String[] outputs) {
         List<Map<String, String>> testCases = new ArrayList<>();
         
         int maxLength = Math.max(inputs.length, outputs.length);
         for (int i = 0; i < maxLength; i++) {
             Map<String, String> testCase = new HashMap<>();
             testCase.put("input", i < inputs.length ? inputs[i] : "");
             testCase.put("output", i < outputs.length ? outputs[i] : "");
             testCases.add(testCase);
         }
         
         return testCases;
     }

   
     private static class ValidationResult {
         private final boolean valid;
         private final String message;
         
         public ValidationResult(boolean valid, String message) {
             this.valid = valid;
             this.message = message;
         }
         
         public boolean isValid() {
             return valid;
         }
         
         public String getMessage() {
             return message;
         }
     }

     private static class LevelData {
         private final String question;
         private final List<String> inputs;
         private final List<String> outputs;
         
         public LevelData(String question, List<String> inputs, List<String> outputs) {
             this.question = question;
             this.inputs = inputs;
             this.outputs = outputs;
         }
         
         public String getQuestion() {
             return question;
         }
        
         public String[] getInputsArray() {
             return inputs.toArray(new String[0]);
         }
         
         public String[] getOutputsArray() {
             return outputs.toArray(new String[0]);
         }
     }
     
 
     private void debugPrintExcelRows(Sheet sheet, int maxRows) {
         logger.info("=== DEBUG: Excel Content ===");
         int rowsToCheck = Math.min(maxRows, sheet.getLastRowNum() + 1);
         
         for (int i = 0; i < rowsToCheck; i++) {
             Row row = sheet.getRow(i);
             if (row == null) {
                 logger.info("Row {}: [NULL ROW]", i);
                 continue;
             }
             
             StringBuilder rowContent = new StringBuilder();
             rowContent.append("Row ").append(i).append(": ");
             
             for (int j = 0; j < 5; j++) { // Check first 5 columns (A-E)
                 Cell cell = row.getCell(j);
                 String cellValue = getCellValueAsString(cell);
                 rowContent.append("[Col ").append((char)('A' + j)).append("='")
                           .append(cellValue).append("'] ");
             }
             
             logger.info(rowContent.toString());
         }
         logger.info("=== END DEBUG ===");
     }*/
     
     // Excel for coding questions
     @PostMapping("/uploadExcel")
     public ResponseEntity<Map<String, Object>> uploadExcel(
             @RequestParam("file") MultipartFile file,
             @RequestParam(value = "language", required = false) String languageParam) {
         
         Map<String, Object> response = new HashMap<>();
         
         try {
             // Validate file
             ValidationResult validation = validateFile(file);
             if (!validation.isValid()) {
                 response.put("success", false);
                 response.put("message", validation.getMessage());
                 return ResponseEntity.badRequest().body(response);
             }
             
             // Process Excel file and save to database
             CodingQuestions savedEntity = processAndSaveExcelFile(file, languageParam);
             
             // Build response
             Map<String, Object> data = buildResponseData(savedEntity);
             
             response.put("success", true);
             response.put("message", "Excel file uploaded and saved successfully");
             response.put("data", data);
             response.put("id", savedEntity.getId());
             
             logger.info("Excel saved successfully: id={}, language={}, easy={} test cases, medium={} test cases, hard={} test cases",
                     savedEntity.getId(),
                     savedEntity.getLanguageName(),
                     savedEntity.getEasyTestCaseCount(),
                     savedEntity.getMediumTestCaseCount(),
                     savedEntity.getHardTestCaseCount());
             
             return ResponseEntity.ok(response);
             
         } catch (InvalidFormatException e) {
             response.put("success", false);
             response.put("message", "Invalid Excel file format: " + e.getMessage());
             logger.error("Invalid Excel format: {}", e.getMessage(), e);
             return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
             
         } catch (IOException e) {
             response.put("success", false);
             response.put("message", "Error reading Excel file: " + e.getMessage());
             logger.error("IO error reading Excel: {}", e.getMessage(), e);
             return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
             
         } catch (Exception e) {
             response.put("success", false);
             response.put("message", "Unexpected error: " + e.getMessage());
             logger.error("Unexpected error processing Excel file: {}", e.getMessage(), e);
             return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
         }
     }
 
     private ValidationResult validateFile(MultipartFile file) {
         if (file.isEmpty()) {
             return new ValidationResult(false, "Uploaded file is empty");
         }
         
         if (file.getSize() > MAX_FILE_SIZE) {
             return new ValidationResult(false,
                 String.format("File size exceeds maximum allowed size of %d MB", MAX_FILE_SIZE / (1024 * 1024)));
         }
         
         String filename = file.getOriginalFilename();
         if (filename == null || filename.trim().isEmpty()) {
             return new ValidationResult(false, "Invalid filename");
         }
         
         String extension = filename.substring(filename.lastIndexOf(".")).toLowerCase();
         if (!ALLOWED_EXTENSIONS.contains(extension)) {
             return new ValidationResult(false,
                 "Invalid file format. Please upload an Excel file (.xlsx or .xls)");
         }
         
         return new ValidationResult(true, "Valid file");
     }
 
    
     private CodingQuestions processAndSaveExcelFile(MultipartFile file, String languageParam)
             throws IOException, InvalidFormatException {
         
         try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
             Sheet sheet = workbook.getSheetAt(0);
             
             logger.info("Excel sheet has {} rows", sheet.getLastRowNum() + 1);
             
             if (sheet.getLastRowNum() < 1) {
                 throw new IllegalArgumentException("Excel sheet is empty or has insufficient data");
             }
             
             // Debug: Print first few rows
             debugPrintExcelRows(sheet, 5);
             
             // Extract language
             String language = languageParam;
             if (language == null || language.trim().isEmpty()) {
                 language = extractLanguageFromExcel(sheet);
                 if (language == null || language.trim().isEmpty()) {
                     language = "Unknown";
                     logger.warn("Could not extract language from Excel, using default: Unknown");
                 }
             }
             
             logger.info("Using language: {}", language);
             
          
             CodingQuestions codingQuestion = new CodingQuestions();
             codingQuestion.setLanguageName(language);
             
          
             LevelData easyData = parseLevel(sheet, "EASY");
             codingQuestion.setEasyQuestion(easyData.getQuestion());
             codingQuestion.setEasyInputArray(easyData.getInputsArray());
             codingQuestion.setEasyExpectedOutputArray(easyData.getOutputsArray());
             
         
             LevelData mediumData = parseLevel(sheet, "MEDIUM");
             codingQuestion.setMediumQuestion(mediumData.getQuestion());
             codingQuestion.setMediumInputArray(mediumData.getInputsArray());
             codingQuestion.setMediumExpectedOutputArray(mediumData.getOutputsArray());
          
             LevelData hardData = parseLevel(sheet, "HARD");
             codingQuestion.setHardQuestion(hardData.getQuestion());
             codingQuestion.setHardInputArray(hardData.getInputsArray());
             codingQuestion.setHardExpectedOutputArray(hardData.getOutputsArray());
           
             return codingQuestion;
 
 
         }
     }
 
   
     private String extractLanguageFromExcel(Sheet sheet) {
         // Method 1: Check first row for language
         Row firstRow = sheet.getRow(0);
         if (firstRow != null && firstRow.getCell(0) != null) {
             String cellValue = getCellValueAsString(firstRow.getCell(0)).trim();
             if (!cellValue.isEmpty()
                 && !cellValue.equalsIgnoreCase("Difficulty")
                 && !cellValue.equalsIgnoreCase("Question")) {
                 return cellValue;
             }
         }
         
         // Method 2: Look for language in first column
         for (int i = 0; i <= Math.min(sheet.getLastRowNum(), 20); i++) {
             Row row = sheet.getRow(i);
             if (row != null && row.getCell(0) != null) {
                 String cellValue = getCellValueAsString(row.getCell(0)).trim();
                 if (cellValue.equalsIgnoreCase("Language") && row.getCell(1) != null) {
                     return getCellValueAsString(row.getCell(1)).trim();
                 }
             }
         }
         
         return null;
     }
 
    
     private LevelData parseLevel(Sheet sheet, String level) {
         List<String> inputs = new ArrayList<>();
         List<String> outputs = new ArrayList<>();
         String question = "";
         boolean foundFirstQuestion = false;
         
         logger.info("=== Parsing {} level ===", level);
         
         for (int i = 1; i <= sheet.getLastRowNum(); i++) {
             Row row = sheet.getRow(i);
             if (row == null) {
                 logger.debug("Row {} is null, skipping", i);
                 continue;
             }
             
             
             Cell difficultyCell = row.getCell(1);
             if (difficultyCell == null) {
                 logger.debug("Row {}: Column B (difficulty) is null, skipping", i);
                 continue;
             }
             
             String difficulty = getCellValueAsString(difficultyCell).trim();
             logger.debug("Row {}: Difficulty = '{}'", i, difficulty);
             
             // Skip if not matching the requested level
             if (!difficulty.equalsIgnoreCase(level)) {
                 logger.debug("Row {}: Difficulty '{}' doesn't match '{}', skipping", i, difficulty, level);
                 continue;
             }
             
             logger.info("Row {}: Found matching difficulty '{}'", i, level);
             
             // Get question from column 2 (C) - only set once
             Cell questionCell = row.getCell(2);
             if (questionCell != null && !foundFirstQuestion) {
            	    String questionText = getCellValueAsString(questionCell).trim();
            	    if (!questionText.isEmpty()) {
            	        question = questionText;
            	        foundFirstQuestion = true;
            	        logger.info("Row {}: Set question = '{}'", i, question.length() > 50 ? question.substring(0, 50) + "..." : question);
            	    }
            	}
 
             
             // Get test case from columns 3 (D) and 4 (E)
             String input = "";
             String output = "";
             
             if (row.getCell(3) != null) {
                 input = getCellValueAsString(row.getCell(3)).trim();
             }
             if (row.getCell(4) != null) {
                 output = getCellValueAsString(row.getCell(4)).trim();
             }
             
             logger.debug("Row {}: Input='{}', Output='{}'", i, input, output);
             
             // Only add test case if there's content
             if (!input.isEmpty() || !output.isEmpty()) {
                 inputs.add(input);
                 outputs.add(output);
                 logger.info("Row {}: Added test case #{} - input='{}', output='{}'", i, inputs.size(), input, output);
             } else {
                 logger.warn("Row {}: Both input and output are empty, skipping test case", i);
             }
         }
         
        
         if (inputs.isEmpty()) {
             inputs.add("");
             outputs.add("");
             logger.warn("No test cases found for level: {}, added empty default", level);
         }
         
         logger.info("=== Finished parsing {}: question='{}', {} test cases ===",
                 level,
                 question.isEmpty() ? "[EMPTY]" : question.substring(0, Math.min(50, question.length())) + "...",
                 inputs.size());
         
         return new LevelData(question, inputs, outputs);
     }
 
     /**
      * Helper method to get cell value as string
      */
     private String getCellValueAsString(Cell cell) {
         if (cell == null) {
             return "";
         }
         
         try {
             switch (cell.getCellType()) {
                 case STRING:
                     return cell.getStringCellValue().trim();
                     
                 case NUMERIC:
                     if (DateUtil.isCellDateFormatted(cell)) {
                         return cell.getDateCellValue().toString();
                     } else {
                         double num = cell.getNumericCellValue();
                         if (num == Math.floor(num) && !Double.isInfinite(num)) {
                             return String.valueOf((long) num);
                         } else {
                             return String.valueOf(num);
                         }
                     }
                     
                 case BOOLEAN:
                     return String.valueOf(cell.getBooleanCellValue());
                     
                 case FORMULA:
                     try {
                         return cell.getStringCellValue();
                     } catch (Exception e) {
                         try {
                             double num = cell.getNumericCellValue();
                             if (num == Math.floor(num) && !Double.isInfinite(num)) {
                                 return String.valueOf((long) num);
                             } else {
                                 return String.valueOf(num);
                             }
                         } catch (Exception e2) {
                             return cell.getCellFormula();
                         }
                     }
                     
                 case BLANK:
                     return "";
                     
                 default:
                     return "";
             }
         } catch (Exception e) {
             logger.warn("Error reading cell value: {}", e.getMessage());
             return "";
         }
     }
 
    
     private Map<String, Object> buildResponseData(CodingQuestions entity) {
         Map<String, Object> data = new HashMap<>();
         data.put("id", entity.getId());
         data.put("language", entity.getLanguageName());
         
         // Easy level
         Map<String, Object> easyMap = new HashMap<>();
         easyMap.put("question", entity.getEasyQuestion());
         easyMap.put("testCases", buildTestCasesList(
             entity.getEasyInputArray(),
             entity.getEasyExpectedOutputArray()
         ));
         data.put("easy", easyMap);
         
         // Medium level
         Map<String, Object> mediumMap = new HashMap<>();
         mediumMap.put("question", entity.getMediumQuestion());
         mediumMap.put("testCases", buildTestCasesList(
             entity.getMediumInputArray(),
             entity.getMediumExpectedOutputArray()
         ));
         data.put("medium", mediumMap);
         
         // Hard level
         Map<String, Object> hardMap = new HashMap<>();
         hardMap.put("question", entity.getHardQuestion());
         hardMap.put("testCases", buildTestCasesList(
             entity.getHardInputArray(),
             entity.getHardExpectedOutputArray()
         ));
         data.put("hard", hardMap);
         
         return data;
     }
 
   
     private List<Map<String, String>> buildTestCasesList(String[] inputs, String[] outputs) {
         List<Map<String, String>> testCases = new ArrayList<>();
         
         int maxLength = Math.max(inputs.length, outputs.length);
         for (int i = 0; i < maxLength; i++) {
             Map<String, String> testCase = new HashMap<>();
             testCase.put("input", i < inputs.length ? inputs[i] : "");
             testCase.put("output", i < outputs.length ? outputs[i] : "");
             testCases.add(testCase);
         }
         
         return testCases;
     }
 
   
     private static class ValidationResult {
         private final boolean valid;
         private final String message;
         
         public ValidationResult(boolean valid, String message) {
             this.valid = valid;
             this.message = message;
         }
         
         public boolean isValid() {
             return valid;
         }
         
         public String getMessage() {
             return message;
         }
     }
 
     private static class LevelData {
         private final String question;
         private final List<String> inputs;
         private final List<String> outputs;
         
         public LevelData(String question, List<String> inputs, List<String> outputs) {
             this.question = question;
             this.inputs = inputs;
             this.outputs = outputs;
         }
         
         public String getQuestion() {
             return question;
         }
         
         public String[] getInputsArray() {
             return inputs.toArray(new String[0]);
         }
         
         public String[] getOutputsArray() {
             return outputs.toArray(new String[0]);
         }
     }
     
 
     private void debugPrintExcelRows(Sheet sheet, int maxRows) {
         logger.info("=== DEBUG: Excel Content ===");
         int rowsToCheck = Math.min(maxRows, sheet.getLastRowNum() + 1);
         
         for (int i = 0; i < rowsToCheck; i++) {
             Row row = sheet.getRow(i);
             if (row == null) {
                 logger.info("Row {}: [NULL ROW]", i);
                 continue;
             }
             
             StringBuilder rowContent = new StringBuilder();
             rowContent.append("Row ").append(i).append(": ");
             
             for (int j = 0; j < 5; j++) { // Check first 5 columns (A-E)
                 Cell cell = row.getCell(j);
                 String cellValue = getCellValueAsString(cell);
                 rowContent.append("[Col ").append((char)('A' + j)).append("='")
                           .append(cellValue).append("'] ");
             }
             
             logger.info(rowContent.toString());
         }
         logger.info("=== END DEBUG ===");
     }
   
     @PostMapping("/saveExamSet")
     @ResponseBody
     public ResponseEntity<?> saveExamSet(
             @RequestParam String languageName,
             @RequestParam String setName,
             @RequestParam String mcqIds,
             @RequestParam Long codingQuestionId) {

         try {

             // check existing set
             Optional<ExamSet> existingSet =
                     examSetRepository
                     .findByLanguageNameAndSetName(
                             languageName,
                             setName
                     );

             ExamSet examSet;

             // UPDATE existing
             if(existingSet.isPresent()) {

                 examSet = existingSet.get();

             } else {

                 examSet = new ExamSet();
             }

             examSet.setLanguageName(languageName);
             examSet.setSetName(setName);
             examSet.setMcqIds(mcqIds);
             examSet.setCodingQuestionId(codingQuestionId);

             examSetRepository.save(examSet);

             return ResponseEntity.ok(
                     "Exam set saved successfully");

         } catch(Exception e) {

             e.printStackTrace();

             return ResponseEntity
                     .badRequest()
                     .body("Error saving exam set");
         }
     }

     @GetMapping("/searchcandidate")
     @ResponseBody
     public List<ExamScreen> searchcandidate(@RequestParam String query,
             Model model) {
    	 query = query.replace("/", "-");
    	return examscreenRepository.searchCandidate(query);
    
     }
     
}
