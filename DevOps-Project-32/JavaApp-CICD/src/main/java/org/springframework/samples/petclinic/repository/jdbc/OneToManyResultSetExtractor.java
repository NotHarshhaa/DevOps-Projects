/*
 * Copyright 2008-2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.samples.petclinic.repository.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.IncorrectResultSizeDataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.util.Assert;

/**
 * An abstract results extractor for row mapping operations that map multiple rows to a single root object. This is
 * useful when joining a one-to-many relationship where there can be multiple child rows returned per parent root.
 * <p>
 * It's assumed that the root type R table has a primary key (id) of type K and that the child type C table has a
 * foreign key of type K referencing the root table's primary key.
 * <p>
 * For example, consider the relationship: "a Customer has one-to-many Addresses". When joining the Customer table with
 * the Address table to build a Customer object, multiple rows would be returned for a Customer if it has more than one
 * Address. This extractor is useful in that case.
 * <p>
 * This class comes from the Spring Data JDBC Extensions project that has been archived in 2019:
 * https://github.com/spring-projects/spring-data-jdbc-ext
 *
 * @author Thomas Risberg
 * @author Keith Donald
 * @author Oliver Gierke
 * @since 1.0
 */
public abstract class OneToManyResultSetExtractor<R, C, K> implements ResultSetExtractor<List<R>> {

	public enum ExpectedResults {
		ANY,
		ONE_AND_ONLY_ONE,
		ONE_OR_NONE,
		AT_LEAST_ONE
	}

	protected final ExpectedResults expectedResults;
	protected final RowMapper<R> rootMapper;
	protected final RowMapper<C> childMapper;

	/**
	 * Creates a new {@link OneToManyResultSetExtractor} from the given {@link RowMapper}s.
	 *
	 * @param rootMapper {@link RowMapper} to map the root entity, must not be {@literal null}.
	 * @param childMapper {@link RowMapper} to map the root entities, must not be {@literal null}.
	 */
	public OneToManyResultSetExtractor(RowMapper<R> rootMapper, RowMapper<C> childMapper) {
		this(rootMapper, childMapper, null);
	}

	/**
	 * Creates a new {@link OneToManyResultSetExtractor} from the given {@link RowMapper}s and {@link ExpectedResults}.
	 *
	 * @param rootMapper {@link RowMapper} to map the root entity, must not be {@literal null}.
	 * @param childMapper {@link RowMapper} to map the root entities, must not be {@literal null}.
	 * @param expectedResults
	 */
	public OneToManyResultSetExtractor(RowMapper<R> rootMapper, RowMapper<C> childMapper, ExpectedResults expectedResults) {

		Assert.notNull(rootMapper, "Root RowMapper must not be null!");
		Assert.notNull(childMapper, "Child RowMapper must not be null!");

		this.childMapper = childMapper;
		this.rootMapper = rootMapper;
		this.expectedResults = expectedResults == null ? ExpectedResults.ANY : expectedResults;
	}

	public List<R> extractData(ResultSet rs) throws SQLException {
		List<R> results = new ArrayList<R>();
		int row = 0;
		boolean more = rs.next();
		if (more) {
			row++;
		}
		while (more) {
			R root = rootMapper.mapRow(rs, row);
			K primaryKey = mapPrimaryKey(rs);
			if (mapForeignKey(rs) != null) {
				while (more && primaryKey.equals(mapForeignKey(rs))) {
					addChild(root, childMapper.mapRow(rs, row));
					more = rs.next();
					if (more) {
						row++;
					}
				}
			}
			else {
				more = rs.next();
				if (more) {
					row++;
				}
			}
			results.add(root);
		}
		if ((expectedResults == ExpectedResults.ONE_AND_ONLY_ONE || expectedResults == ExpectedResults.ONE_OR_NONE) &&
				results.size() > 1) {
			throw new IncorrectResultSizeDataAccessException(1, results.size());
		}
		if ((expectedResults == ExpectedResults.ONE_AND_ONLY_ONE || expectedResults == ExpectedResults.AT_LEAST_ONE) &&
				results.size() < 1) {
			throw new IncorrectResultSizeDataAccessException(1, 0);
		}
		return results;
	}

	/**
	 * Map the primary key value to the required type.
	 * This method must be implemented by subclasses.
	 * This method should not call <code>next()</code> on
	 * the ResultSet; it is only supposed to map values of the current row.
	 *
	 * @param rs the ResultSet
	 * @return the primary key value
	 * @throws SQLException
	 */
	protected abstract K mapPrimaryKey(ResultSet rs) throws SQLException;

	/**
	 * Map the foreign key value to the required type.
	 * This method must be implemented by subclasses.
	 * This method should not call <code>next()</code> on
	 * the ResultSet; it is only supposed to map values of the current row.
	 *
	 * @param rs the ResultSet
	 * @return the foreign key value
	 * @throws SQLException
	 */
	protected abstract K mapForeignKey(ResultSet rs) throws SQLException;

	/**
	 * Add the child object to the root object
	 * This method must be implemented by subclasses.
	 *
	 * @param root the Root object
	 * @param child the Child object
	 */
	protected abstract void addChild(R root, C child);

}
