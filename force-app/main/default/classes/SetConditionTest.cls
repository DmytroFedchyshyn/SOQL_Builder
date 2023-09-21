@IsTest
private class SetConditionTest {

    @IsTest
    static void testValidSetCondition_In() {
        SetCondition condition = new SetCondition('Industry', SetCondition.Operator.In_s, new Set<String>{'Tech', 'Finance'});
        Assert.areEqual('Industry IN (\'Tech\',\'Finance\')', condition.toSql());
    }

    @IsTest
    static void testValidSetCondition_Includes() {
        SetCondition condition = new SetCondition('Industry', SetCondition.Operator.Includes_s, new Set<String>{'Tech'});
        Assert.areEqual('Industry INCLUDES (\'Tech\')', condition.toSql());
    }

    @IsTest
    static void testValidSetCondition_Excludes() {
        SetCondition condition = new SetCondition('Industry', SetCondition.Operator.Excludes_s, new Set<String>{'Tech'});
        Assert.areEqual('Industry EXCLUDES (\'Tech\')', condition.toSql());
    }

    @IsTest
    static void testValidSetCondition_MultipleMatching() {
        SetCondition condition = new SetCondition('Industry', SetCondition.Operator.In_s, new Set<String>{'Tech', 'Finance'}, true);
        Assert.areEqual('Industry IN (\'Tech\';\'Finance\')', condition.toSql());
    }

    @IsTest
    static void testInvalidSetCondition_NoField() {
        Boolean exceptionThrown = false;
        try {
            SetCondition condition = new SetCondition('', SetCondition.Operator.In_s, new Set<String>{'Tech'});
            condition.toSql();
        } catch (IllegalArgumentException e) {
            exceptionThrown = true;
        }
        Assert.isTrue(exceptionThrown);
    }

    @IsTest
    static void testInvalidSetCondition_NoOperator() {
        Boolean exceptionThrown = false;
        try {
            SetCondition condition = new SetCondition('Industry', null, new Set<String>{'Tech'});
            condition.toSql();
        } catch (IllegalArgumentException e) {
            exceptionThrown = true;
        }
        Assert.isTrue(exceptionThrown, 'Expected IllegalArgumentException to be thrown');
    }

    @IsTest
    static void testInvalidSetCondition_NoValue() {
        Boolean exceptionThrown = false;
        try {
            SetCondition condition = new SetCondition('Industry', SetCondition.Operator.In_s, new Set<String>{});
            condition.toSql();
        } catch (IllegalArgumentException e) {
            exceptionThrown = true;
        }
        Assert.isTrue(exceptionThrown, 'Expected IllegalArgumentException to be thrown');
    }

    @IsTest
    static void testInvalidSetCondition_NoFieldAndOperator() {
        Boolean exceptionThrown = false;
        try {
            SetCondition condition = new SetCondition('', null, new Set<String>{'Tech'});
            condition.toSql();
        } catch (IllegalArgumentException e) {
            exceptionThrown = true;
        }
        Assert.isTrue(exceptionThrown, 'Expected IllegalArgumentException to be thrown');
    }
}
