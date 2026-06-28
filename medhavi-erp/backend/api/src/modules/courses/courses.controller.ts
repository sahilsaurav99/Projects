import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PermissionsGuard } from '../auth/guards/permissions.guard';
import { RequirePermissions } from '../auth/decorators/permissions.decorator';
import { CoursesService } from './courses.service';
import { CreateCourseDto } from './dto/create-course.dto';
import { ListCoursesQueryDto } from './dto/list-courses.query';
import { UpdateCourseDto } from './dto/update-course.dto';

/**
 * CoursesController
 *
 * Permission keys mirror the subject-offerings module:
 *   courses.read   | courses.create | courses.update
 *   courses.delete | courses.restore
 */
@ApiTags('Courses')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller({ path: 'courses', version: '1' })
export class CoursesController {
  constructor(private readonly courses: CoursesService) {}

  @Get()
  @RequirePermissions('courses.read')
  @ApiOperation({ summary: 'List courses (paginated, filterable).' })
  @ApiOkResponse({ description: 'Paginated list of courses.' })
  list(@Query() query: ListCoursesQueryDto) {
    return this.courses.findAll(query);
  }

  @Get(':id')
  @RequirePermissions('courses.read')
  @ApiOperation({ summary: 'Get a single course by id.' })
  findOne(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.courses.findOne(id);
  }

  @Post()
  @RequirePermissions('courses.create')
  @ApiOperation({ summary: 'Create a new course.' })
  create(@Body() dto: CreateCourseDto) {
    return this.courses.create(dto);
  }

  @Patch(':id')
  @RequirePermissions('courses.update')
  @ApiOperation({ summary: 'Update a course (partial).' })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateCourseDto,
  ) {
    return this.courses.update(id, dto);
  }

  @Delete(':id')
  @RequirePermissions('courses.delete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft-delete a course (sets deletedAt).' })
  remove(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.courses.remove(id);
  }

  @Post(':id/restore')
  @RequirePermissions('courses.restore')
  @ApiOperation({ summary: 'Restore a previously soft-deleted course.' })
  restore(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.courses.restore(id);
  }
}
