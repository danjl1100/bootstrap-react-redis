const chai = require('chai');
const chaiHttp = require('chai-http');
const server = require('../server');
const expect = chai.expect;

chai.use(chaiHttp);

describe('Back-end Server', () => {
	describe('/GET greeting', () => {
		it('returns the standard greeting', (done) => {
			chai.request(server)
				.get('/api/greeting')
				.end((err, res) => {
					expect(res).to.have.status(200);
					expect(res.body).to.have.property('greeting').eql('Hello World!');
				});
				done();
		});
	});

	describe('Redis client', () => {
		it('has the expected server version', (done) => {
			expect(server.redis_client).to.have.property('server_info')
				.to.have.property('versions')
				.eql([5, 0, 5]);
			done();
		});
	});
});
