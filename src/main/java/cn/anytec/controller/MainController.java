package cn.anytec.controller;

import cn.anytec.MainApplication;
import cn.anytec.config.AppConfig;
import cn.anytec.findface.FindFaceHandler;
import cn.anytec.mongo.MongoDB;
import cn.anytec.mongo.MongoHandler;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@Controller
public class MainController implements EmbeddedServletContainerCustomizer{

    private static final Logger logger = LoggerFactory.getLogger(MainApplication.class);

    @Autowired
    FindFaceHandler findFaceHandler;
    @Autowired
    AppConfig appConfig;
    @Autowired
    MongoHandler mongoHandler;
    @Autowired
    MongoDB mongoDB;

//    @Value("${testHtml}")
//    private String test;

    @Autowired
    private SimpMessagingTemplate template;

    @Override
    public void customize(ConfigurableEmbeddedServletContainer container) {
        //container.setPort(8090);
    }

    @MessageMapping("/hello")
    @SendTo("/topic/greetings")
//    @RequestMapping("/hellos")
    public Greeting hello(String helloMessage){
        return new Greeting("hello,"+helloMessage);
    }

//    @RequestMapping("/pushToClient")
//    @ResponseBody
//    public void handleSubscription(String pushJson) {
//        template.convertAndSend("/topic/greetings",pushJson );
////        return "hello sub";
//    }

    @RequestMapping(value = "/")
    public String index(Map<String,String> map){
//        map.put("test",test);
        return "portfolio";
    }

    @RequestMapping(value = "/ws")
    public String ws(){
//        map.put("test",test);
        return "index";
    }



//    @RequestMapping(value = "/anytec/index.html")
//    public String test(Map<String,String> map){
////        map.put("test",test);
//        return "index";
//    }

//    @RequestMapping(value = "/config")
//    @ResponseBody
//    public String method(Map<String,String> map){
//        map.put("test",test);
//        return test;
//    }

    @RequestMapping(value = "/anytec/historyManager.html")
    public String history(Map<String,String> map){
        return "historyManager";
    }


    @RequestMapping(value = "/anytec/identify",method = RequestMethod.POST)
    @ResponseBody
    public String anytecIdentify(@RequestParam("photo") MultipartFile file,@RequestParam("token")String token,@RequestParam("camera")String camera,HttpServletRequest request){
        byte[] pic = null;
        try{
            if(!file.isEmpty()){
                pic = file.getBytes();
            }
            if(pic == null)
                return "error";
            /*String contentType = file.getContentType().replace("image/","");
            if(file.getContentType().equals("application/octet-stream")){
                String originalFilename = file.getOriginalFilename();
                if(originalFilename.substring(originalFilename.length()-3).equals("png")){
                    contentType = "png";
                }else if(originalFilename.substring(originalFilename.length()-4).equals("webp")){
                    contentType = "webp";
                }else {
                    return "error_photo_type";
                }
            }*/

            JSONObject reply = findFaceHandler.imageIdentify(request.getParameterMap(),pic);
            if(reply != null){
//                mongoHandler.notifyMongo(reply);
                template.convertAndSend("/topic/greetings",reply.toJSONString() );
                return "success";
            }

        } catch (IOException e) {
            logger.error(e.getMessage());
        }
        return "error";
    }

    @RequestMapping(value = "/anytec/getFaceList")
    @ResponseBody
    public JSONObject getFaceList(HttpServletRequest request){
        List<JSONObject> jsonObjectList =  mongoDB.getFaceByCondition(request.getParameterMap());
        String total = mongoDB.getFaceNumByCondition(request.getParameterMap())+"";
        if(jsonObjectList == null)
            return null;
        JSONObject result =new JSONObject();
        result.put("rows",jsonObjectList);
        result.put("total",total);
        return result;
    }


}
