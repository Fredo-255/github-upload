@isTest
public without sharing class FailTestTest {
    @isTest
    public static void testFailure() {
        String message;
        FailTest.addFailure('test');
        try {
            message = 'OK';
            FailTest.Here('test');
        }
        catch (Exception e) {
            message = e.getmessage();
        }

        System.assertEquals('default test exception on test', message);

    }


    @isTest
    public static void makeFailingClassFail() {
        FailTest.addFailure('test');
        String result = FailingClass.failOnTest();
        System.assertEquals('failed', result);
    }




    @isTest
    public static void makeFailingClassNotFail() {
        String result = FailingClass.failOnTest();
        System.assertEquals('not failed', result);
    }
}