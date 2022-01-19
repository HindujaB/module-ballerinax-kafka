/*
 * Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.kafka.plugin;

import io.ballerina.projects.plugins.codeaction.CodeActionArgument;
import io.ballerina.projects.plugins.codeaction.CodeActionInfo;
import io.ballerina.tools.text.LinePosition;
import io.ballerina.tools.text.LineRange;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import java.io.IOException;
import java.nio.file.Path;
import java.util.List;

import static io.ballerina.stdlib.kafka.plugin.KafkaCodeTemplate.NODE_LOCATION;

/**
 * A class for testing code actions.
 */
public class CodeSnippetGenerationCodeActionTest extends AbstractCodeActionTest {

    @Test(dataProvider = "testDataProvider")
    public void testEmptyServiceCodeAction(String srcFile, int line, int offset, String resultFile)
            throws IOException {
        Path filePath = RESOURCE_PATH.resolve("ballerina_sources")
                .resolve("snippet_gen_service_1")
                .resolve(srcFile);
        Path resultPath = RESOURCE_PATH.resolve("expected_sources")
                .resolve("service_1")
                .resolve(resultFile);
        performTest(filePath, LinePosition.from(line, offset),
                getExpectedCodeAction("service.bal", 2, 64), resultPath);
    }

    @Test(dataProvider = "testDataProvider")
    public void testServiceWithVariablesCodeAction(String srcFile, int line, int offset, String resultFile)
            throws IOException {
        Path filePath = RESOURCE_PATH.resolve("ballerina_sources")
                .resolve("snippet_gen_service_2")
                .resolve(srcFile);
        Path resultPath = RESOURCE_PATH.resolve("expected_sources")
                .resolve("service_2")
                .resolve(resultFile);
        performTest(filePath, LinePosition.from(line, offset),
                getExpectedCodeAction("service.bal", 5, 1), resultPath);
    }

    @DataProvider
    private Object[][] testDataProvider() {
        return new Object[][]{
                {"service.bal", 2, 0, "result.bal"}
        };
    }

    private CodeActionInfo getExpectedCodeAction(String filePath, int line, int offset) {
        LineRange lineRange = LineRange.from(filePath, LinePosition.from(2, 0),
                LinePosition.from(line, offset));
        CodeActionArgument locationArg = CodeActionArgument.from(NODE_LOCATION, lineRange);
        CodeActionInfo codeAction = CodeActionInfo.from("Insert service template", List.of(locationArg));
        codeAction.setProviderName("KAFKA_112/ballerinax/kafka/ADD_REMOTE_FUNCTION_CODE_SNIPPET");
        return codeAction;
    }
}
