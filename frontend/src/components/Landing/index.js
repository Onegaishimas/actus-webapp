import React, { PureComponent } from 'react';
import { Contract } from '../Contract';
import { Container, Row, Col } from 'react-bootstrap'; // Updated import
import axios from 'axios';
import './Landing.css';

export class Landing extends PureComponent {
  state = {
    contractDetails: [],
    contractIdentifiers: []
  }

  componentDidMount() {
    axios.get(`/data/actus-dictionary.json`)
      .then(res => {
        this.setState({
          contractDetails: res.data.taxonomy
        })
      });
    axios.get(`/data/covered-contracts.json`)
      .then(res => {
        this.setState({
          contractIdentifiers: res.data.contracts
        })
      });
  }

  render() {
    let contractDetails = this.state.contractDetails
    let contractIdentifiers = this.state.contractIdentifiers
    return (
      <div>

        {/* intro text */}
        <div className="section-intro">Choose a Contract Type from the list below in order to define and evaluate specific financial contracts:</div>

        {/* contract grid */}
        <Container className="contract-grid"> {/* Use Container for overall layout */}
          <Row>
            {
              Object.keys(contractDetails).map((key) => {
                if (contractIdentifiers.indexOf(key) !== -1) { // Use !== for comparison
                  return (
                    <Col key={key} md={4}> {/* Use Col for grid columns, adjust 'md' as needed */}
                      <Contract
                        contractType={contractDetails[key].acronym}
                        name={contractDetails[key].name}
                        description={contractDetails[key].description} />
                    </Col>
                  )
                } else {
                  return null; // Important: Return null for filtered items
                }
              })
            }
          </Row>
        </Container>
      </div>
    );
  }
}