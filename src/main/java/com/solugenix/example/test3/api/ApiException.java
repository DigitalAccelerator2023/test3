package com.solugenix.example.test3.api;

@javax.annotation.Generated(value = "io.swagger.codegen.languages.SpringCodegen", date = "2023-06-23T13:13:35.451+05:30")

public class ApiException extends Exception{
    private int code;
    public ApiException (int code, String msg) {
        super(msg);
        this.code = code;
    }
}
