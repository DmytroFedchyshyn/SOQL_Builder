@IsTest
public class FieldTypeParserTest {

    @IsTest
    static void testStringType() {
        String strValue = 'Test String';
        String parsedValue = FieldTypeParser.parse(strValue);
        Assert.areEqual('\'Test String\'', parsedValue);
    }

    @IsTest
    static void testDateType() {
        Date dateValue = Date.newInstance(2023, 9, 19);
        String parsedValue = FieldTypeParser.parse(dateValue);
        Assert.areEqual(dateValue.format(), parsedValue);
    }

    @IsTest
    static void testDateTimeType() {
        Datetime datetimeValue = Datetime.newInstance(2023, 9, 19, 12, 30, 0);
        String parsedValue = FieldTypeParser.parse(datetimeValue);
        Assert.areEqual(datetimeValue.format(), parsedValue);
    }

    @IsTest
    static void testBooleanType() {
        Boolean boolValue = true;
        String parsedValue = FieldTypeParser.parse(boolValue);
        Assert.areEqual('TRUE', parsedValue);

        boolValue = false;
        parsedValue = FieldTypeParser.parse(boolValue);
        Assert.areEqual('FALSE', parsedValue);
    }

    @IsTest
    static void testNumericTypes() {
        Decimal decValue = 123.456;
        String parsedValue = FieldTypeParser.parse(decValue);
        Assert.areEqual('123.456', parsedValue);

        Integer intValue = 123;
        parsedValue = FieldTypeParser.parse(intValue);
        Assert.areEqual('123', parsedValue);

        Double doubleValue = 123.456;
        parsedValue = FieldTypeParser.parse(doubleValue);
        Assert.areEqual('123.456', parsedValue);
    }

    @IsTest
    static void testNullType() {
        Object nullValue = null;
        String parsedValue = FieldTypeParser.parse(nullValue);
        Assert.areEqual('null', parsedValue);
    }
}
