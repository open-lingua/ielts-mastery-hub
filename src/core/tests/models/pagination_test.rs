use app_lib::models::pagination::{build_pagination, offset_for, PaginationParams};
use rstest::rstest;

mod normalize {
    use super::*;

    #[test]
    fn it_returns_defaults_when_page_and_page_size_are_none() {
        // Arrange
        let params = PaginationParams {
            page: None,
            page_size: None,
        };

        // Act
        let (page, page_size) = params.normalize();

        // Assert
        assert_eq!(page, 1);
        assert_eq!(page_size, 10);
    }

    #[rstest]
    #[case(0, 1)]
    #[case(-5, 1)]
    #[case(1, 1)]
    #[case(3, 3)]
    fn it_clamps_page_to_at_least_one(#[case] input: i64, #[case] expected: i64) {
        // Arrange
        let params = PaginationParams {
            page: Some(input),
            page_size: None,
        };

        // Act
        let (page, _) = params.normalize();

        // Assert
        assert_eq!(page, expected);
    }

    #[rstest]
    #[case(0, 1)]
    #[case(-1, 1)]
    #[case(1, 1)]
    #[case(50, 50)]
    #[case(100, 100)]
    #[case(101, 100)]
    #[case(1_000, 100)]
    fn it_clamps_page_size_between_one_and_max(#[case] input: i64, #[case] expected: i64) {
        // Arrange
        let params = PaginationParams {
            page: None,
            page_size: Some(input),
        };

        // Act
        let (_, page_size) = params.normalize();

        // Assert
        assert_eq!(page_size, expected);
    }
}

mod build_pagination_meta {
    use super::*;

    #[test]
    fn it_returns_zero_total_pages_when_there_are_no_items() {
        // Arrange & Act
        let meta = build_pagination(1, 10, 0);

        // Assert
        assert_eq!(meta.total_pages, 0);
    }

    #[test]
    fn it_marks_has_next_and_has_prev_false_when_there_are_no_items() {
        // Arrange & Act
        let meta = build_pagination(1, 10, 0);

        assert_eq!(meta.has_next, false);
        assert_eq!(meta.has_prev, false);
    }

    #[test]
    fn it_computes_total_pages_when_items_divide_evenly() {
        // Arrange & Act
        let meta = build_pagination(1, 10, 20);

        // Assert
        assert_eq!(meta.total_pages, 2);
    }

    #[test]
    fn it_rounds_total_pages_up_when_items_do_not_divide_evenly() {
        // Arrange & Act
        let meta = build_pagination(1, 10, 21);

        // Assert
        assert_eq!(meta.total_pages, 3);
    }

    #[test]
    fn it_marks_has_prev_false_when_on_first_page() {
        // Arrange & Act
        let meta = build_pagination(1, 10, 30);

        // Assert
        assert_eq!(meta.has_prev, false);
    }

    #[test]
    fn it_marks_has_prev_true_when_past_first_page() {
        // Arrange & Act
        let meta = build_pagination(2, 10, 30);

        // Assert
        assert_eq!(meta.has_prev, true);
    }

    #[test]
    fn it_marks_has_next_true_when_before_last_page() {
        // Arrange & Act
        let meta = build_pagination(1, 10, 30);

        // Assert
        assert_eq!(meta.has_next, true);
    }

    #[test]
    fn it_marks_has_next_false_when_on_last_page() {
        // Arrange & Act
        let meta = build_pagination(3, 10, 30);

        // Assert
        assert_eq!(meta.has_next, false);
    }
}

mod offset {
    use super::*;

    #[rstest]
    #[case(1, 10, 0)]
    #[case(2, 10, 10)]
    #[case(3, 25, 50)]
    fn it_computes_the_sql_offset(#[case] page: i64, #[case] page_size: i64, #[case] expected: i64) {
        // Arrange & Act
        let offset = offset_for(page, page_size);

        // Assert
        assert_eq!(offset, expected);
    }
}
