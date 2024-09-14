import React, { Component } from 'react';
import { Container, Row, Col } from 'react-bootstrap'; // Updated import
import Header from '../Header';
import Footer from '../Footer';
import './Layout.css';

export class Layout extends Component {
  displayName = Layout.name

  render() {
    return (
      <Container fluid> {/* Use Container for main layout */}
        <Row>
          <Col sm={12}>
            <div className="main-container">
              <Header />
              {this.props.children}
              <Footer />
            </div>
          </Col>
        </Row>
      </Container> 
    );
  }
}