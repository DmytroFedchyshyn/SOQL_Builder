@IsTest
private class FieldConditionTest {

    @IsTest
    static void testStringField() {
        FieldCondition condition = new FieldCondition('Name', FieldCondition.Operator.Equals, 'TestName');
        Assert.areEqual('Name=\'TestName\'', condition.toSql());
    }

    @IsTest
    static void testIntegerField() {
        FieldCondition condition = new FieldCondition('Age__c', FieldCondition.Operator.Equals, 30);
        Assert.areEqual('Age__c=30', condition.toSql());
    }

    @IsTest
    static void testDoubleField() {
        FieldCondition condition = new FieldCondition('Amount__c', FieldCondition.Operator.Equals, 100.50);
        Assert.areEqual('Amount__c=100.50', condition.toSql());
    }

    @IsTest
    static void testDateField() {
        Date today = Date.today();
        FieldCondition condition = new FieldCondition('Date__c', FieldCondition.Operator.Equals, today);
        Assert.areEqual('Date__c=' + today.format(), condition.toSql());
    }

    @IsTest
    static void testDatetimeField() {
        Datetime now = Datetime.now();
        FieldCondition condition = new FieldCondition('Datetime__c', FieldCondition.Operator.Equals, now);
        // Here you need to include what you expect after parsing datetime to SOQL
        Assert.areEqual('Datetime__c=' + now.format(), condition.toSql());
    }

    @IsTest
    static void testBooleanField() {
        FieldCondition condition = new FieldCondition('IsActive__c', FieldCondition.Operator.Equals, true);
        Assert.areEqual('IsActive__c=TRUE', condition.toSql());
    }
}
