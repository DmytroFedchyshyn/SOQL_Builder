# SOQL Builder

## Introduction

SOQL Builder is a Salesforce development utility designed to simplify the construction of SOQL queries in Apex. It provides a fluent API that makes building queries intuitive, while also promoting best practices and scalability.

### Features

* Fluent API for constructing SOQL queries
* Support for basic and complex SOQL query constructs
* Scalable and maintainable design
* Comprehensive test coverage

### Installation

1. Clone the GitHub repository.
2. Deploy the code into your Salesforce org via SFDX or any other deployment tool.
3. Optionally, run the test suite to verify the installation.

### Usage

#### Basic Query
```
SoqlBuilder builder = new SoqlBuilder();
builder.selectFields(new Set<String>{'Id', 'Name'})
.fromSobject(Account.SObjectType)
.limitRecords(10);

String query = builder.toSql();
```

### Complex Query with Conditions
```
FieldCondition condition1 = new FieldCondition('Name', FieldCondition.Operator.Equals, 'Test Account');
FieldCondition condition2 = new FieldCondition('AnnualRevenue', FieldCondition.Operator.NotEquals, '1000000');

GroupCondition group = new GroupCondition(GroupCondition.GroupType.AND_C);
group.add(condition1);
group.add(condition2);

SoqlBuilder builder = new SoqlBuilder();
builder.selectFields(new Set<String>{'Id', 'Name'})
       .fromSobject(Account.SObjectType)
       .whereClause(group)
       .limitRecords(10);

String query = builder.toSql();
```

### Testing

Run the test suite to validate the functionality of SOQL Builder. You can use the following SFDX command to run the tests:
`sfdx force:apex:test:run -c -d classes -y`

### Contributing

To contribute to this project, please fork the repository and create a pull request.

### License

This project is licensed under the MIT License. See the LICENSE.md file for details.