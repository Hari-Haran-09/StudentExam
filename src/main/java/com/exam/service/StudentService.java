
package com.exam.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.exam.entity.Student;
import com.exam.repository.StudentRepository;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;

@Service
public class StudentService {

    @Autowired
    private  StudentRepository userRepository;
    
    
    @Autowired
    private JavaMailSender javamails;
    

    public void mailsender(String email,String name) throws MessagingException {
    	String html = """
    			<html>
    			<body style="margin:0; padding:0; background:#ffffff; font-family:Arial, sans-serif; color:#333;">
    			  
    			  <!-- Outer wrapper -->
    			  <table width="100%%" cellpadding="0" cellspacing="0">
    			    <tr>
    			      <td align="center">
 
    			        <!-- Main container -->
    			        <table width="600" cellpadding="0" cellspacing="0" style="width:600px; max-width:600px;">
    			          
    			          <!-- Header image -->
    			          <tr>
    			            <td align="center" style="padding:20px 0;">
    			              <img src="cid:logo" style="width:100%%; max-width:600px; display:block;">
    			            </td>
    			          </tr>
 
    			          <!-- Content -->
    			          <tr>
    			            <td style="padding:0 20px; text-align:left; font-size:14px; line-height:1.6;">
 
    			              <p>Hi <b>%s</b>,</p>
 
    			              <p>Your registration has been successfully completed.</p>
 
    			              <p>
    			                You are now eligible to appear for the upcoming online examination.
    			                Please carefully follow the instructions below to avoid any issues on exam day.
    			              </p>
 
    			              <h4 style="margin-top:25px;">Exam Instructions:</h4>
 
    			              <ul style="padding-left:18px; margin-top:10px;">
    			                <li>Download and install the Safe Exam Browser (SEB):
    			                  <a href="https://safeexambrowser.org/download_en.html">Click here</a>
    			                </li>
    			                <li>Download the exam file:
    			                  <a href="https://exam.nssorg.com/StudentExam/student/login">Click here</a>
    			                </li>
    			                <li>Ensure your laptop is fully charged and has a stable internet connection</li>
    			                <li>Close all other applications before starting the exam</li>
    			                <li>Double-click the exam file and log in using your registered credentials</li>
    			              </ul>
 
    			              <p>All the best for your exam.</p>
 
    			              <p>
    			                Regards,<br>
    			                NSS Team
    			              </p>
 
    			              <hr style="border:none; border-top:1px solid #e0e0e0; margin:30px 0;">
 
    			            </td>
    			          </tr>
 
    			          <!-- Social icons -->
    			          <tr>
    			            <td align="center" style="padding-bottom:20px;">
    			              <a href="https://www.linkedin.com/company/nssorg">
    			                <img src="cid:linkedin" width="26" style="margin:0 6px;">
    			              </a>
    			              <a href="https://www.facebook.com/p/Nithish-Software-Soluctions-PVT-LTD-61560461565737/">
    			                <img src="cid:facebook" width="26" style="margin:0 6px;">
    			              </a>
    			              <a href="https://www.instagram.com/nss_software/">
    			                <img src="cid:instagram" width="26" style="margin:0 6px;">
    			              </a>
    			            </td>
    			          </tr>
 
    			          <!-- Footer image -->
    			          <tr>
    			            <td align="center">
    			              <img src="cid:footerLogo" style="width:100%%; max-width:600px; display:block;">
    			            </td>
    			          </tr>
 
    			        </table>
 
    			      </td>
    			    </tr>
    			  </table>
 
    			</body>
    			</html>
    			""".formatted(name);
 
 
    	System.err.println(email);
        System.err.println(name);
        
        //NEW COMMENT END
        
        MimeMessage msg = javamails.createMimeMessage();
        MimeMessageHelper helper =
                new MimeMessageHelper(msg, true, "UTF-8");
 
        helper.setTo(email);
        helper.setSubject("Registration Successful");
        helper.setText(html, true);
 
        // inline images from classpath
        helper.addInline("logo",
                new ClassPathResource("static/images/nssorg.jpg"));
 
        helper.addInline("linkedin",
                new ClassPathResource("static/images/linkednss.png"));
 
        helper.addInline("facebook",
                new ClassPathResource("static/images/facebooknss.png"));
 
        helper.addInline("instagram",
                new ClassPathResource("static/images/instanss.png"));
 
        helper.addInline("footerLogo",
                new ClassPathResource("static/images/nsS.jpg"));
 
        javamails.send(msg);
 
    }
 
    public Student registerUser(Student student) {
    	
        return userRepository.save(student);
    }

    public Student loginUser(String email, String rawPassword) {
        return userRepository.findByEmail(email)
                .filter(u -> rawPassword.equals(u.getPassword()))
                .orElse(null);
    }
    public List<Student> getAllStudents() {
        return userRepository.findAll();
    }
    
	@SuppressWarnings("deprecation")
	public String extractTextFromImage(MultipartFile file) throws IOException, TesseractException {
		Tesseract tesseract = new Tesseract();
		// Set the path to your tessdata directory
		tesseract.setDatapath("C:\\Users\\chatu\\OneDrive\\Documents\\Desktop");
		tesseract.setTessVariable("user_defined_dpi", "300");
		// Save the uploaded file to a temporary location
		Path tempFile = Files.createTempFile("tempImage", file.getOriginalFilename());
		file.transferTo(tempFile.toFile());
		// Perform OCR on the image
		String result = tesseract.doOCR(tempFile.toFile());
		// Delete the temporary file
		Files.delete(tempFile);
		return result;		
    }	
}
