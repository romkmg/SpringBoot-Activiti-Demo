package com.example.myact;

//import com.example.myact.entity.User;

import org.activiti.engine.IdentityService;
import org.activiti.engine.identity.User;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class MyactApplicationTests {
	@Autowired
	IdentityService identityService;

	@Test
	public void contextLoads() {
//		User user = new User();
//		user.setFirstName("user");
//		user.setPassword("123");
//		user.setEmail("MG@MG.com");
//		user.setLastName("MG");
//		userService.add(user);
//		System.out.println(user.toString());

		User user = identityService.createUserQuery().userId("d5f427fe-d5b3-41fa-874b-2d875a24c1ca").singleResult();

		System.out.println(user.getFirstName());

	}

}
