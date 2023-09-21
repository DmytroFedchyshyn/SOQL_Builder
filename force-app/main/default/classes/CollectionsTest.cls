@IsTest
public class CollectionsTest {

    @IsTest
    static void testIsEmpty_SetString_Null() {
        Boolean result = Collections.isEmpty((Set<String>)null);
        Assert.isTrue(result, 'Expected true when the set is null');
    }

    @IsTest
    static void testIsEmpty_SetString_Empty() {
        Boolean result = Collections.isEmpty(new Set<String>());
        Assert.isTrue(result, 'Expected true when the set is empty');
    }

    @IsTest
    static void testIsEmpty_SetString_NotEmpty() {
        Boolean result = Collections.isEmpty(new Set<String>{'Test'});
        Assert.isFalse(result, 'Expected false when the set is not empty');
    }

    @IsTest
    static void testIsEmpty_SetSObject_Null() {
        Boolean result = Collections.isEmpty((Set<SObject>)null);
        Assert.isTrue(result, 'Expected true when the set is null');
    }

    @IsTest
    static void testIsEmpty_SetSObject_Empty() {
        Boolean result = Collections.isEmpty(new Set<SObject>());
        Assert.isTrue(result, 'Expected true when the set is empty');
    }

    @IsTest
    static void testIsEmpty_SetSObject_NotEmpty() {
        Account acc = new Account(Name = 'Test');
        Boolean result = Collections.isEmpty(new Set<SObject>{acc});
        Assert.isFalse(result, 'Expected false when the set is not empty');
    }
}
