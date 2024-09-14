import React, { PureComponent } from 'react';
import { Col, Container, Row } from 'react-bootstrap';
import { Navigate } from 'react-router-dom'; // Updated import
import './Results.css';
import { Graph } from '../Graph';

export class Results extends PureComponent {

  state = {
    results: [],
    currentTab: 'Table',
    contractId: '',
    redirect: false,
    url: '',
  }

  componentDidMount() {
    let response = [...this.props.location.state.data];
    this.setState({
      results: response,
      contractId: this.props.location.state.contractId,
      url: this.props.location.state.url,
      allAnswers: this.props.location.state.allAnswers,
      formTerms: this.props.location.state.formTerms
    });
  }

  handleBackToForm(e) {
    this.setState({
      redirect: true
    })
  }

  render() {
    let { results, currentTab, contractId, redirect, url } = this.state;

    if (redirect)
      return <Navigate to={{ pathname: url, state: { backFromResults: true, allAnswers: this.state.allAnswers, formTerms: this.state.formTerms } }} /> // Use Navigate

    return (
      <div id="results-container" identifier="" version="">
        <Container fluid> {/* Use Container for overall layout */}
          <Row>
            <Col sm={12} className="results-main-wrapper">
              <span className="results-title">RESULT:  <span className="contract-id">Contract ID - {contractId}</span></span>
              <span className="results-description"> </span>
            </Col>
          </Row>
          <Row>
            <Col id="resultsGraph" sm={12} className="results-graph-wrapper">
              <Graph results={results} />
              <div className="back-to-form">
                <input type="button" value="Back to Form" onClick={() => this.handleBackToForm()} />
              </div>
            </Col>
          </Row>
          {currentTab === 'Table' &&
            <Row>
              <Col sm={12}>
                <Container fluid className="results-table-wrapper"> {/* Use Container instead of Gr!d */}
                  <Row className="table-header-container">
                    <Col sm={1} className="table-header">Event Date</Col>
                    <Col sm={1} className="table-header">Event Type</Col>
                    <Col sm={2} className="table-header">Event Value</Col>
                    <Col sm={2} className="table-header">Event Currency</Col>
                    <Col sm={2} className="table-header">Nominal Value</Col>
                    <Col sm={2} className="table-header">Nominal Rate</Col>
                    <Col sm={2} className="table-header">Nominal Accrued</Col>
                  </Row>
                  {
                    results.map((result, index) => {
                      let d = new Date(result.time.toString());
                      //console.log(d.getDate(), (d.getDate()).toString().length);
                      let month = (d.getMonth() + 1).toString().length < 2 ? "0" + (d.getMonth() + 1) : d.getMonth() + 1;
                      let day = (d.getDate()).toString().length < 2 ? "0" + (d.getDate()) : d.getDate();
                      let dateString = d.getFullYear() + "-" + month + "-" + day;
                      return (
                        <Row key={index}>
                          <Col className="cell-content" sm={1}>{dateString}</Col>
                          <Col className="cell-content" sm={1}>{result.type}</Col>
                          <Col className="cell-content" sm={2}>{result.payoff}</Col>
                          <Col className="cell-content" sm={2}>{result.currency}</Col>
                          <Col className="cell-content" sm={2}>{result.nominalValue}</Col>
                          <Col className="cell-content" sm={2}>{result.nominalRate}</Col>
                          <Col className="cell-content" sm={2}>{result.nominalAccrued}</Col>
                        </Row>
                      )
                    })
                  }
                </Container> {/* Close Container */}
              </Col>
            </Row>
          }
        </Container> {/* Close Container */}
      </div>
    )
  }
}