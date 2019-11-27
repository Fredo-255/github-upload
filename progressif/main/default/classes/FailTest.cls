public class FailTest {
    // Méthodes pour passer dans les try/catch afin d'assurer une meilleure couvertuire de test
    // Utilisation :
    // * Dans la classe à tester :
    //     - Insérer une clause FailTest.here(<cause de l'échec>) ou <cause de l'échec> est une chaîne à réutiliser dans le test pour déclencher une exception à ce niveau
    //     - Voir FailingClass.cls pour un exemple
    // * Dans la classe de test
    //     - Ajouter une clause FailTest.addFailure(<cause de l'échec> avant l'appel à la méthode devant échouer
    //     - Voir FailTestTest.cls pour un exemple


    private static Map<String, Exception> Failures = new Map<String, Exception>();



    public static void addFailure(String failure, Exception e) {
        Failures.put(failure, e);
    }

    public static void addFailure(String failure) {
        addFailure(failure, new testException('default test exception on ' + failure));
    }

    public static void Here(String failure) {
        if(test.isRunningTest() && Failures.containsKey(failure)) {
            throw Failures.get(failure);
        }
    }

    public class testException extends Exception {

    }
}