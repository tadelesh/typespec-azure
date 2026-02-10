import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;
using Azure.ClientGenerator.Core;

@doc("Test for @convenientAPI decorator to control generation of convenient methods")
@scenarioService("/azure/client-generator-core/convenient-api")
@service
namespace _Specs_.Azure.ClientGenerator.Core.ConvenientAPI;

@doc("Input model for operations")
model InputModel {
  name: string;
}

@doc("Output model for operations")
model OutputModel {
  id: string;
  name: string;
  status: string;
}

// Scenario 1: Disable convenient API for a single operation
@scenarioDoc("""
  Test operation with convenient API disabled via @convenientAPI(false).
  Only protocol method should be generated, not the convenient method.
  
  Expected behavior:
  - No high-level convenient method generated
  - Only low-level protocol method available
  """)
@scenario
@route("/disable-single")
@post
@convenientAPI(false)
op disableSingleOperation(@body body: InputModel): OutputModel;

// Scenario 2: Disable convenient API for all operations in an interface
@scenarioDoc("""
  Test interface with convenient API disabled for all operations.
  All operations in this interface should only generate protocol methods.
  """)
@convenientAPI(false)
@route("/disable-interface")
interface DisableInterface {
  @scenario
  @scenarioDoc("""
    Operation 1 in interface with convenient API disabled.
    Should only generate protocol method.
    """)
  @route("/op1")
  @post
  op operation1(@body body: InputModel): OutputModel;

  @scenario
  @scenarioDoc("""
    Operation 2 in interface with convenient API disabled.
    Should only generate protocol method.
    """)
  @route("/op2")
  @post
  op operation2(@body body: InputModel): OutputModel;
}

// Scenario 3: Disable convenient API for namespace
@scenarioDoc("""
  Test namespace with convenient API disabled for all operations.
  All operations in this namespace should only generate protocol methods.
  """)
@convenientAPI(false)
@route("/disable-namespace")
namespace DisableNamespace {
  @scenario
  @scenarioDoc("""
    Operation 1 in namespace with convenient API disabled.
    Should only generate protocol method.
    """)
  @route("/op1")
  @post
  op operation1(@body body: InputModel): OutputModel;

  @scenario
  @scenarioDoc("""
    Operation 2 in namespace with convenient API disabled.
    Should only generate protocol method.
    """)
  @route("/op2")
  @post
  op operation2(@body body: InputModel): OutputModel;
}

// Scenario 4: Override namespace-level setting for specific operation
@scenarioDoc("""
  Test namespace with convenient API disabled, but one operation re-enabled.
  """)
@convenientAPI(false)
@route("/override-namespace")
namespace OverrideNamespace {
  @scenario
  @scenarioDoc("""
    Operation with convenient API disabled (inherited from namespace).
    Should only generate protocol method.
    """)
  @route("/protocol-only")
  @post
  op protocolOnlyOperation(@body body: InputModel): OutputModel;

  @scenario
  @scenarioDoc("""
    Operation with convenient API re-enabled via @convenientAPI(true).
    Should generate both convenient and protocol methods.
    """)
  @route("/both-methods")
  @post
  @convenientAPI(true)
  op bothMethodsOperation(@body body: InputModel): OutputModel;
}

// Scenario 5: Language-specific convenient API control
@scenarioDoc("""
  Test operation with convenient API disabled only for specific languages.
  Python should not have convenient method, but other languages should.
  """)
@scenario
@route("/language-specific")
@post
@convenientAPI(false, "python")
op languageSpecificOperation(@body body: InputModel): OutputModel;

// Scenario 6: Exclude multiple languages
@scenarioDoc("""
  Test operation with convenient API disabled for multiple languages.
  Python and Java should not have convenient methods.
  """)
@scenario
@route("/multiple-languages")
@post
@convenientAPI(false, "python")
@convenientAPI(false, "java")
op multipleLanguagesOperation(@body body: InputModel): OutputModel;
