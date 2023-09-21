@IsTest
private class SoqlBuilderTest {
    @IsTest
    static void testSelectFields() {
        SoqlBuilder builder = new SoqlBuilder();
        Set<String> fields = new Set<String>{'Id', 'Name'};
        builder.selectFields(fields)
                .fromSobject(Account.SObjectType);

        String actualQuery = builder.toSql();
        String expectedQuery = 'SELECT Id,Name FROM Account';

        Assert.areEqual(expectedQuery, actualQuery);
    }

    @IsTest
    static void testOrderBy() {
        SoqlBuilder builder = new SoqlBuilder();
        builder.selectFields(new Set<String>{'Id'})
                .fromSobject(Contact.SObjectType)
                .orderBy('LastName');

        String actualQuery = builder.toSql();
        String expectedQuery = 'SELECT Id FROM Contact ORDER BY LastName';

        Assert.areEqual(expectedQuery, actualQuery);
    }

    @IsTest
    static void testLimitRecords() {
        SoqlBuilder builder = new SoqlBuilder();
        builder.selectFields(new Set<String>{'Id'})
                .fromSobject(Opportunity.SObjectType)
                .limitRecords(5);

        String actualQuery = builder.toSql();
        String expectedQuery = 'SELECT Id FROM Opportunity LIMIT 5';

        Assert.areEqual(expectedQuery, actualQuery);
    }

    @IsTest
    static void testCondition() {
        FieldCondition cond = new FieldCondition('StageName', FieldCondition.Operator.Equals, 'Closed Won');
        SoqlBuilder builder = new SoqlBuilder();
        builder.selectFields(new Set<String>{'Id'})
                .fromSobject(Opportunity.SObjectType)
                .whereClause(cond);

        String actualQuery = builder.toSql();
        String expectedQuery = 'SELECT Id FROM Opportunity WHERE StageName=\'Closed Won\'';

        Assert.areEqual(expectedQuery, actualQuery);
    }

    @IsTest
    static void testInvalidField() {
        SoqlBuilder builder = new SoqlBuilder();
        Boolean exceptionThrown = false;

        try {
            builder.selectFields(new Set<String>{'InvalidField'})
                    .fromSobject(Contact.SObjectType)
                    .toSql();
        } catch (IllegalArgumentException e) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown, 'Expected an exception for invalid field but did not receive one.');
    }

    @IsTest
    static void testEmptyFields() {
        SoqlBuilder builder = new SoqlBuilder();
        Boolean exceptionThrown = false;

        try {
            builder.fromSobject(Contact.SObjectType).toSql();
        } catch (IllegalArgumentException e) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown, 'Expected an exception for empty fields but did not receive one.');
    }

    @IsTest
    static void testMissingSObjectType() {
        SoqlBuilder builder = new SoqlBuilder();
        Boolean exceptionThrown = false;

        try {
            builder.selectFields(new Set<String>{'Id'}).toSql();
        } catch (IllegalArgumentException e) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown, 'Expected an exception for missing SObjectType but did not receive one.');
    }

    @IsTest
    static void testInvalidSObjectType() {
        SoqlBuilder builder = new SoqlBuilder();
        Boolean exceptionThrown = false;
        try {
            builder.selectFields(new Set<String>{'Id'})
                    .fromSobject('InvalidType')
                    .toSql();
        } catch (Exception e) {
            exceptionThrown = true;
        }

        Assert.isTrue(exceptionThrown, 'Expected an exception for invalid SObjectType but did not receive one.');
    }

    @IsTest
    static void testZeroLimit() {
        SoqlBuilder builder = new SoqlBuilder();
        builder.selectFields(new Set<String>{'Id'})
                .fromSobject(Contact.SObjectType)
                .limitRecords(0);
        String actualQuery = builder.toSql();
        String expectedQuery = 'SELECT Id FROM Contact';

        Assert.areEqual(expectedQuery, actualQuery, 'Expected query to be the same as the input query.');
    }

    @IsTest
    static void testNegativeLimit() {
        SoqlBuilder builder = new SoqlBuilder();
        builder.selectFields(new Set<String>{'Id'})
                .fromSobject(Contact.SObjectType)
                .limitRecords(-5);
        String actualQuery = builder.toSql();
        String expectedQuery = 'SELECT Id FROM Contact';

        Assert.areEqual(expectedQuery, actualQuery);
    }

    @IsTest
    static void testGroupConditionAnd() {
        GroupCondition groupCondition = new GroupCondition(GroupCondition.GroupType.AND_C);
        groupCondition.add(new FieldCondition('Name', FieldCondition.Operator.Equals, 'Test'));
        groupCondition.add(new FieldCondition('Id', FieldCondition.Operator.NotEquals, null));

        String actualSql = groupCondition.toSql();
        String expectedSql = '(Name=\'Test\' AND Id!=null)';

        Assert.areEqual(expectedSql, actualSql);
    }

    @IsTest
    static void testGroupConditionOr() {
        GroupCondition groupCondition = new GroupCondition(GroupCondition.GroupType.OR_C);
        groupCondition.add(new FieldCondition('Name', FieldCondition.Operator.Equals, 'Test'));
        groupCondition.add(new FieldCondition('Id', FieldCondition.Operator.NotEquals, null));

        String actualSql = groupCondition.toSql();
        String expectedSql = '(Name=\'Test\' OR Id!=null)';

        Assert.areEqual(expectedSql, actualSql);
    }

    @IsTest
    static void testSetConditionIn() {
        Set<String> values = new Set<String>{'Val1', 'Val2'};
        SetCondition setCondition = new SetCondition('Field', SetCondition.Operator.In_s, values);

        String actualSql = setCondition.toSql();
        String expectedSql = 'Field IN (\'Val1\',\'Val2\')';

        Assert.areEqual(expectedSql, actualSql);
    }

    @IsTest
    static void testSetConditionIncludes() {
        Set<String> values = new Set<String>{'Val1', 'Val2'};
        SetCondition setCondition = new SetCondition('Field', SetCondition.Operator.Includes_s, values);

        String actualSql = setCondition.toSql();
        String expectedSql = 'Field INCLUDES (\'Val1\',\'Val2\')';

        Assert.areEqual(expectedSql, actualSql);
    }

    @IsTest
    static void testComplexCondition() {
        SoqlBuilder builder = new SoqlBuilder();

        // Define simple FieldConditions
        FieldCondition cond1 = new FieldCondition('Name', FieldCondition.Operator.Equals, 'Test Account');
        FieldCondition cond2 = new FieldCondition('AnnualRevenue', FieldCondition.Operator.NotEquals, 1000000);

        // Define a SetCondition
        Set<String> industryValues = new Set<String>{'Technology', 'Finance'};
        SetCondition setCond = new SetCondition('Industry', SetCondition.Operator.In_s, industryValues);

        // Combine FieldConditions using GroupCondition AND
        GroupCondition andGroup = new GroupCondition(GroupCondition.GroupType.AND_C);
        andGroup.add(cond1);
        andGroup.add(cond2);

        // Combine the AND GroupCondition with SetCondition using OR
        GroupCondition orGroup = new GroupCondition(GroupCondition.GroupType.OR_C);
        orGroup.add(andGroup);
        orGroup.add(setCond);

        // Create the SOQL query using the complex OR condition
        builder.selectFields(new Set<String>{'Id', 'Name'})
                .fromSobject(Account.SObjectType)
                .whereClause(orGroup);

        // The resulting SQL
        String actualQuery = builder.toSql();
        String expectedQuery = 'SELECT Id,Name FROM Account WHERE ((Name=\'Test Account\' AND AnnualRevenue!=1000000) OR Industry IN (\'Technology\',\'Finance\'))';

        // Validate the generated SQL
        Assert.areEqual(expectedQuery, actualQuery);
    }

    @IsTest
    static void testRealDbQuery() {
        // Given
        Account acc = new Account(Name = 'Test Account', AnnualRevenue = 2000000, Industry = 'Technology');
        insert acc;

        Contact con = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id);
        insert con;

        FieldCondition condition = new FieldCondition('AccountId', FieldCondition.Operator.Equals,  acc.Id);
        SoqlBuilder builder = new SoqlBuilder();
        builder.selectFields(new Set<String>{'Id', 'LastName'})
                .fromSobject(Contact.SObjectType)
                .whereClause(condition);

        // When
        String query = builder.toSql();
        List<Contact> contacts = Database.query(query);

        // Then
        Assert.areNotEqual(null, contacts, 'Contacts should not be null.');
        Assert.areEqual(1, contacts.size(), 'Should find exactly one matching contact.');
        Assert.areEqual('Doe', contacts[0].LastName, 'LastName should match.');
    }

    @IsTest
    static void testComplexConditionRealDbQuery() {
        // Prepare Data
        Account acc1 = new Account(Name = 'Test Account', AnnualRevenue = 2000000, Industry = 'Technology');
        Account acc2 = new Account(Name = 'Another Account', AnnualRevenue = 1000000, Industry = 'Finance');
        insert new List<Account>{acc1, acc2};

        // Prepare Complex Query using SoqlBuilder
        FieldCondition condition1 = new FieldCondition('Name', FieldCondition.Operator.Equals, 'Test Account');
        FieldCondition condition2 = new FieldCondition('AnnualRevenue', FieldCondition.Operator.NotEquals, 1000000);
        SetCondition condition3 = new SetCondition('Industry', SetCondition.Operator.In_s, new Set<String>{'Technology', 'Finance'});

        GroupCondition andGroup = new GroupCondition(GroupCondition.GroupType.AND_C);
        andGroup.add(condition1);
        andGroup.add(condition2);

        GroupCondition orGroup = new GroupCondition(GroupCondition.GroupType.OR_C);
        orGroup.add(andGroup);
        orGroup.add(condition3);

        SoqlBuilder builder = new SoqlBuilder();
        builder.selectFields(new Set<String>{'Id', 'Name'})
                .fromSobject(Account.SObjectType)
                .whereClause(orGroup);

        // Execute Query
        String query = builder.toSql();
        List<Account> accounts = Database.query(query);

        // Verify
        Assert.areNotEqual(null, accounts, 'Accounts should not be null.');
        Assert.areEqual(2, accounts.size(), 'Should find exactly two matching accounts.');
    }
}