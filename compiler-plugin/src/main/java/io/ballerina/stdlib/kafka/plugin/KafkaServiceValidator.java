/*
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import io.ballerina.compiler.api.SemanticModel;
import io.ballerina.compiler.api.symbols.AnnotationSymbol;
import io.ballerina.compiler.api.symbols.MethodSymbol;
import io.ballerina.compiler.api.symbols.ServiceDeclarationSymbol;
import io.ballerina.compiler.api.symbols.Symbol;
import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.stdlib.kafka.plugin.PluginConstants.CompilationErrors;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;

import java.util.List;
import java.util.Optional;

/**
 * Kafka service compilation validator.
 */
public class KafkaServiceValidator {

    public void validate(SyntaxNodeAnalysisContext context) {
        ServiceDeclarationNode serviceDeclarationNode = (ServiceDeclarationNode) context.node();
        NodeList<Node> memberNodes = serviceDeclarationNode.members();

        validateAnnotation(context);
        FunctionDefinitionNode onConsumerRecord = null;

        for (Node node : memberNodes) {
            FunctionDefinitionNode functionDefinitionNode = (FunctionDefinitionNode) node;
            if (node.kind() == SyntaxKind.OBJECT_METHOD_DEFINITION) {
                MethodSymbol methodSymbol = PluginUtils.getMethodSymbol(context, functionDefinitionNode);
                Optional<String> functionName = methodSymbol.getName();
                if (functionName.isPresent()) {
                    if (functionName.get().equals(PluginConstants.ON_RECORDS_FUNC)) {
                        onConsumerRecord = functionDefinitionNode;
                    } else {
                        validateNonKafkaFunction(functionDefinitionNode, context);
                    }
                }
            } else {
                validateNonKafkaFunction(functionDefinitionNode, context);
            }
        }
        new KafkaFunctionValidator(context, onConsumerRecord).validate();
    }

    public void validateNonKafkaFunction(FunctionDefinitionNode functionDefinitionNode,
                                        SyntaxNodeAnalysisContext context) {
        if (functionDefinitionNode.kind() == SyntaxKind.RESOURCE_ACCESSOR_DEFINITION) {
            context.reportDiagnostic(PluginUtils.getDiagnostic(CompilationErrors.INVALID_FUNCTION,
                    DiagnosticSeverity.ERROR, functionDefinitionNode.location()));
        } else {
            if (PluginUtils.isRemoteFunction(context, functionDefinitionNode)) {
                context.reportDiagnostic(PluginUtils.getDiagnostic(CompilationErrors.INVALID_REMOTE_FUNCTION,
                        DiagnosticSeverity.ERROR, functionDefinitionNode.location()));
            }
        }
    }

    private void validateAnnotation(SyntaxNodeAnalysisContext context) {
        SemanticModel semanticModel = context.semanticModel();
        ServiceDeclarationNode serviceDeclarationNode = (ServiceDeclarationNode) context.node();
        Optional<Symbol> symbol = semanticModel.symbol(serviceDeclarationNode);
        if (symbol.isPresent()) {
            ServiceDeclarationSymbol serviceDeclarationSymbol = (ServiceDeclarationSymbol) symbol.get();
            List<AnnotationSymbol> symbolList = serviceDeclarationSymbol.annotations();
            if (!symbolList.isEmpty()) {
                context.reportDiagnostic(PluginUtils.getDiagnostic(CompilationErrors.INVALID_ANNOTATION_NUMBER,
                        DiagnosticSeverity.ERROR, serviceDeclarationNode.location()));
            }
        }
    }
}
