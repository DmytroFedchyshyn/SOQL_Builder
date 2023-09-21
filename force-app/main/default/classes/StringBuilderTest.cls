@IsTest
public class StringBuilderTest {

    @IsTest static void testAppendAndToString() {
        // Given
        StringBuilder builder = new StringBuilder();

        // When
        builder.append('Hello, ');
        builder.append('world');
        builder.append('!');

        // Then
        String result = builder.toString();
        Assert.areEqual('Hello, world!', result);
    }

    @IsTest static void testEmptyStringBuilder() {
        // Given
        StringBuilder builder = new StringBuilder();

        // When
        String result = builder.toString();

        // Then
        Assert.areEqual('', result);
    }

    @IsTest static void testSingleAppend() {
        // Given
        StringBuilder builder = new StringBuilder();

        // When
        builder.append('Hello!');

        // Then
        String result = builder.toString();
        Assert.areEqual('Hello!', result);
    }

    @IsTest static void testMultipleAppends() {
        // Given
        StringBuilder builder = new StringBuilder();

        // When
        builder.append('H').append('e').append('l').append('l').append('o');

        // Then
        String result = builder.toString();
        Assert.areEqual('Hello', result);
    }

    @IsTest static void testAppendWithNull() {
        // Given
        StringBuilder builder = new StringBuilder();

        // When
        builder.append('Hello, ').append(null).append('world');

        // Then
        String result = builder.toString();
        Assert.areEqual('Hello, world', result); // null should not affect the result
    }
}
