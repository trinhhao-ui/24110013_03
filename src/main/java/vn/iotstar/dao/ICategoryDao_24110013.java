package vn.iotstar.dao;

import vn.iotstar.entity.Category_24110013;
import java.util.List;

public interface ICategoryDao_24110013 {
    void insert(Category_24110013 category);
    void update(Category_24110013 category);
    void delete(int categoryId);
    Category_24110013 findById(int categoryId);
    List<Category_24110013> findAll();
    long countVideosByCategoryId(int categoryId);
}
