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
import { CourseModulesService } from './course-modules.service';
import { CreateCourseModuleDto } from './dto/create-course-module.dto';
import { ListCourseModulesQueryDto } from './dto/list-course-modules.query';
import { UpdateCourseModuleDto } from './dto/update-course-module.dto';

/**
 * CourseModulesController
 *
 * Permission keys mirror the courses module:
 *   course-modules.read   | course-modules.create | course-modules.update
 *   course-modules.delete | course-modules.restore
 */
@ApiTags('Course Modules')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller({ path: 'course-modules', version: '1' })
export class CourseModulesController {
  constructor(private readonly courseModules: CourseModulesService) {}

  @Get()
  @RequirePermissions('course-modules.read')
  @ApiOperation({ summary: 'List course modules (paginated, filterable).' })
  @ApiOkResponse({ description: 'Paginated list of course modules.' })
  list(@Query() query: ListCourseModulesQueryDto) {
    return this.courseModules.findAll(query);
  }

  @Get(':id')
  @RequirePermissions('course-modules.read')
  @ApiOperation({ summary: 'Get a single course module by id.' })
  findOne(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.courseModules.findOne(id);
  }

  @Post()
  @RequirePermissions('course-modules.create')
  @ApiOperation({ summary: 'Create a new course module.' })
  create(@Body() dto: CreateCourseModuleDto) {
    return this.courseModules.create(dto);
  }

  @Patch(':id')
  @RequirePermissions('course-modules.update')
  @ApiOperation({ summary: 'Update a course module (partial).' })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateCourseModuleDto,
  ) {
    return this.courseModules.update(id, dto);
  }

  @Delete(':id')
  @RequirePermissions('course-modules.delete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft-delete a course module (sets deletedAt).' })
  remove(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.courseModules.remove(id);
  }

  @Post(':id/restore')
  @RequirePermissions('course-modules.restore')
  @ApiOperation({ summary: 'Restore a previously soft-deleted course module.' })
  restore(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.courseModules.restore(id);
  }
}
