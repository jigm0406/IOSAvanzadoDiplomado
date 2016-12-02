//
//  ViewController.swift
//  LoginEventosCep
//
//  Created by Mario Jimenez on 15/11/16.
//  Copyright © 2016 Mario Jimenez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import CoreData
import Alamofire

class ViewController: UIViewController,FBSDKLoginButtonDelegate
    {
    var conexion:NSURLConnection?
    var datosRecibidos:NSMutableData?
    //para el json 
    var jsonArray:NSArray?
    let loginbutton: FBSDKLoginButton = {
    let button = FBSDKLoginButton()
    button.readPermissions=["email"]
        return button
    }()
    
    @IBOutlet weak var ScrollView: UIScrollView!
    var keywordUp:Bool = false
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBAction func btnSave(_ sender: UIButton)
    {
        if self.txtName.text != "" && self.txtEmail.text != ""
        {
            //guardar los datos por medio del webservice
                        self.save()
            // pasar al siguiente activity
            performSegue(withIdentifier: "login", sender: nil)
        }
        else{
            let ac:UIAlertController = UIAlertController(title: "Error", message: "Todos los campos son requeridos", preferredStyle: UIAlertControllerStyle.alert)
            self.present(ac, animated: true, completion: nil)
          }
    }
    
    func save(){
        let urlstring = "http://132.248.246.61:74/scepw.svc/create"
        let parameters : Dictionary = ["clave" : "88888882","nombre" : self.txtName.text! ,"correo" :self.txtEmail.text!]
        Alamofire.request(urlstring, method: .post, parameters: parameters,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                if response.result.value != nil{
                    let JSON = response.result.value
                    let dataPerson = JSON as! [String:Any]
                    let arreglo = JSON as! NSDictionary
                    self.jsonArray = arreglo as? NSArray
                    print("JSON:\(arreglo)")
                    print("JSON2:\(arreglo["id"] as? String)")
                    let datos = "\(JSON)"
                    print("datos:")
                    print(arreglo["clave"] as? String)
                    print(arreglo["nombre"] as? String)
                    print(arreglo["correo"] as? String)
                }
        }
    }

    func keyboardShow(notification: NSNotification)
    {
        if keywordUp
        {
            return
        }
        else
        {
            self.adjustscroll(zoom: true,notification: notification)
        }
    }
    
    func keyboardHide(notification: NSNotification)
    {
        self.adjustscroll(zoom: false, notification: notification)
    }

    func adjustscroll(zoom:Bool,notification:NSNotification)
    {
       /* let info:NSDictionary = notification.userInfo! as NSDictionary
        let value = info.allKeysForObject(UIKeyboardFrameEndUserInfoKey)
        let frameKeyboard:CGRect = (value as AnyObject).cgRectValue
        var size:CGSize = self.ScrollView.contentSize
        if zoom
        {
            size.height += frameKeyboard.size.height
        }
        else
        {
            size.height -= frameKeyboard.size.height
        }
        self.ScrollView.contentSize = size
        keywordUp = zoom*/
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    override func viewDidLoad()
        {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        let maxY:CGFloat = self.txtEmail.frame.maxY
        let ancho:CGFloat = screenSize.width//UIScreen.main.bounds.width
        let newSize:CGSize = CGSize(width: ancho,height: maxY+30.0)
        self.ScrollView.contentSize = newSize
        loginbutton.center=view.center
        loginbutton.delegate = self
            //if let token = FBSDKAccessToken.current() {
            //if (FBSDKAccessToken.current()) != nil {
            if let token = FBSDKAccessToken.current(){
            regresaPerfil()
            }
        }
    
    func regresaPerfil(){
    print("perfil facebook")
        let parameters = ["fields": "email, first_name, last_name,  picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            
             let resultNew = result as? [String:Any]
            let email = resultNew?["email"]  as! String
            print(email)
          }
    }
    
    override func didReceiveMemoryWarning()
        {
            super.didReceiveMemoryWarning()
        }
    
    func logoutFB()
    {
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrent(nil)
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
         regresaPerfil()
    }
    
      func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        print("User Logged Out")
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        print ("No se puede acceder al WS usuarios: Error del server")
    }
    
    func conectionResponse (notif: NSNotification){
        
     }
    
}

