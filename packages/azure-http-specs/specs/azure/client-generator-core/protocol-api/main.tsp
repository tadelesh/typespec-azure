import "@typespec/http";
import "@typespec/spector";
import "@azure-tools/typespec-client-generator-core";

using Http;
using Spector;
using Azure.ClientGenerator.Core;

@doc("Test for @protocolAPI decorator to control generation of protocol methods")
@scenarioService("/azure/client-generator-core/protocol-api")
@service
namespace _Specs_.Azure.ClientGenerator.Core.ProtocolAPI;

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

// Scenario 1: Disable protocol API for a single operation
@scenarioDoc("""
  Test operation with protocol API disabled via @protocolAPI(false).
  Only convenient method should be generated, not the protocol method.
  
  Expected behavior:
  - No low-level protocol method generated
  - Only high-level convenient method available
  """)
@scenario
@route("/disable-single")
@post
@protocolAPI(false)
op disableSingleOperation(@body body: InputModel): OutputModel;

// Scenario 2: Disable protocol API for all operations in an interface
@scenarioDoc("""
  Test interface with protocol API disabled for all operations.
  All operations in this interface should only generate convenient methods.
  """)
@protocolAPI(false)
@route("/disable-interface")
interface DisableInterface {
  @scenario
  @scenarioDoc("""
    Operation 1 in interface with protocol API disabled.
    Should only generate convenient method.
    """)
  @route("/op1")
  @post
  op operation1(@body body: InputModel): OutputModel;

  @scenario
  @scenarioDoc("""
    Operation 2 in interface with protocol API disabled.
    Should only generate convenient method.
    """)
  @route("/op2")
  @post
  op operation2(@body body: InputModel): OutputModel;
}

// Scenario 3: Disable protocol API for namespace
@scenarioDoc("""
  Test namespace with protocol API disabled for all operations.
  All operations in this namespace should only generate convenient methods.
  """)
@protocolAPI(false)
@route("/disable-namespace")
namespace DisableNamespace {
  @scenario
  @scenarioDoc("""
    Operation 1 in namespace with protocol API disabled.
    Should only generate convenient method.
    """)
  @route("/op1")
  @post
  op operation1(@body body: InputModel): OutputModel;

  @scenario
  @scenarioDoc("""
    Operation 2 in namespace with protocol API disabled.
    Should only generate convenient method.
    """)
  @route("/op2")
  @post
  op operation2(@body body: InputModel): OutputModel;
}

// Scenario 4: Override namespace-level setting for specific operation
@scenarioDoc("""
  Test namespace with protocol API disabled, but one operation re-enabled.
  """)
@protocolAPI(false)
@route("/override-namespace")
namespace OverrideNamespace {
  @scenario
  @scenarioDoc("""
    Operation with protocol API disabled (inherited from namespace).
    Should only generate convenient method.
    """)
  @route("/convenient-only")
  @post
  op convenientOnlyOperation(@body body: InputModel): OutputModel;

  @scenario
  @scenarioDoc("""
    Operation with protocol API re-enabled via @protocolAPI(true).
    Should generate both convenient and protocol methods.
    """)
  @route("/both-methods")
  @post
  @protocolAPI(true)
  op bothMethodsOperation(@body body: InputModel): OutputModel;
}

// Scenario 5: Language-specific protocol API control
@scenarioDoc("""
  Test operation with protocol API disabled only for specific languages.
  Python should not have protocol method, but other languages should.
  """)
@scenario
@route("/language-specific")
@post
@protocolAPI(false, "python")
op languageSpecificOperation(@body body: InputModel): OutputModel;

// Scenario 6: Exclude multiple languages
@scenarioDoc("""
  Test operation with protocol API disabled for multiple languages.
  Python and Java should not have protocol methods.
  """)
@scenario
@route("/multiple-languages")
@post
@protocolAPI(false, "python")
@protocolAPI(false, "java")
op multipleLanguagesOperation(@body body: InputModel): OutputModel;

// Scenario 7: Combined convenient and protocol API control
@scenarioDoc("""
  Test operation with both convenient and protocol API control.
  Different languages should have different method availability.
  """)
@scenario
@route("/combined-control")
@post
@convenientAPI(false, "python")
@protocolAPI(false, "java")
op combinedControlOperation(@body body: InputModel): OutputModel;
