@isTest
public without sharing class FailingClass {
// Utilisée par les tests de FailTestTest

    public static String failOnTest() {
        String message = 'not failed';
        try {
            FailTest.Here('test');                
        } catch (Exception e) {
            message = 'failed';
        }
        return message;

    }
}